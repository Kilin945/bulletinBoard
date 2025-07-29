package com.bulletinboard.controller;

import com.bulletinboard.model.BulletinBoard;
import com.bulletinboard.service.BulletinBoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.List;

/**
 * 公告欄控制器
 * 處理所有 HTTP 請求和回應
 */
@Controller
@RequestMapping("/bulletins")
public class BulletinBoardController {

    @Autowired
    private BulletinBoardService bulletinBoardService;

    // 每頁顯示筆數
    private static final int PAGE_SIZE = 10;

    /**
     * 首頁重定向到公告列表
     */
    @RequestMapping("/")
    public String home() {
        return "redirect:/bulletins/list";
    }

    /**
     * 顯示公告列表（支援分頁和搜尋）
     * 
     * @param page   頁碼（預設0）
     * @param search 搜尋關鍵字
     * @param model  Spring MVC Model
     * @return 列表頁面
     */
    @GetMapping("/list")
    public String listBulletins(@RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String search,
            Model model) {
        try {
            List<BulletinBoard> bulletins;
            int totalPages;
            long totalBulletins;

            // 根據是否有搜尋條件決定查詢方式
            if (search != null && !search.trim().isEmpty()) {
                bulletins = bulletinBoardService.searchBulletinsByTitle(search);
                totalBulletins = bulletins.size();
                totalPages = (int) Math.ceil((double) totalBulletins / PAGE_SIZE);

                // 手動分頁處理搜尋結果
                int start = page * PAGE_SIZE;
                int end = Math.min(start + PAGE_SIZE, bulletins.size());
                if (start < bulletins.size()) {
                    bulletins = bulletins.subList(start, end);
                } else {
                    bulletins.clear();
                }
            } else {
                bulletins = bulletinBoardService.getBulletins(page, PAGE_SIZE);
                totalBulletins = bulletinBoardService.getTotalBulletins();
                totalPages = bulletinBoardService.getTotalPages(PAGE_SIZE);
            }

            // 傳遞資料到頁面
            model.addAttribute("bulletins", bulletins);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalBulletins", totalBulletins);
            model.addAttribute("search", search);
            model.addAttribute("pageSize", PAGE_SIZE);

            return "bulletin/list";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "載入公告列表失敗: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * 顯示新增公告表單
     */
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        BulletinBoard bulletin = new BulletinBoard();
        // 設定預設值
        bulletin.setPublisher("Administrator");
        bulletin.setPublishDate(LocalDate.now());
        bulletin.setEndDate(LocalDate.now().plusDays(30)); // 預設30天後到期

        model.addAttribute("bulletin", bulletin);
        model.addAttribute("action", "create");
        return "bulletin/form";
    }

    /**
     * 處理新增公告請求
     */
    @PostMapping("/create")
    public String createBulletin(@ModelAttribute BulletinBoard bulletin,
            @RequestParam(required = false) MultipartFile attachmentFile,
            RedirectAttributes redirectAttributes) {
        try {
            BulletinBoard savedBulletin = bulletinBoardService.createBulletin(bulletin, attachmentFile);
            redirectAttributes.addFlashAttribute("success",
                    "公告「" + savedBulletin.getTitle() + "」建立成功！");
            return "redirect:/bulletins/list";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "建立公告失敗: " + e.getMessage());
            redirectAttributes.addFlashAttribute("bulletin", bulletin);
            return "redirect:/bulletins/new";
        }
    }

    /**
     * 顯示公告詳細內容
     */
    @GetMapping("/view/{id}")
    public String viewBulletin(@PathVariable Integer id, Model model) {
        try {
            BulletinBoard bulletin = bulletinBoardService.getBulletinById(id);
            if (bulletin == null) {
                model.addAttribute("error", "公告不存在（ID: " + id + "）");
                return "error/404";
            }

            model.addAttribute("bulletin", bulletin);
            return "bulletin/view";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "載入公告失敗: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * 顯示編輯公告表單
     */
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        try {
            BulletinBoard bulletin = bulletinBoardService.getBulletinById(id);
            if (bulletin == null) {
                model.addAttribute("error", "公告不存在（ID: " + id + "）");
                return "error/404";
            }

            model.addAttribute("bulletin", bulletin);
            model.addAttribute("action", "update");
            return "bulletin/form";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "載入公告失敗: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * 處理更新公告請求
     */
    @PostMapping("/update/{id}")
    public String updateBulletin(@PathVariable Integer id,
            @ModelAttribute BulletinBoard bulletin,
            @RequestParam(required = false) MultipartFile attachmentFile,
            RedirectAttributes redirectAttributes) {
        try {
            bulletin.setId(id); // 確保 ID 正確
            BulletinBoard updatedBulletin = bulletinBoardService.updateBulletin(bulletin, attachmentFile);
            redirectAttributes.addFlashAttribute("success",
                    "公告「" + updatedBulletin.getTitle() + "」更新成功！");
            return "redirect:/bulletins/list";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "更新公告失敗: " + e.getMessage());
            return "redirect:/bulletins/edit/" + id;
        }
    }

    /**
     * 刪除公告
     */
    @PostMapping("/delete/{id}")
    public String deleteBulletin(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            BulletinBoard bulletin = bulletinBoardService.getBulletinById(id);
            if (bulletin == null) {
                redirectAttributes.addFlashAttribute("error", "公告不存在，無法刪除");
                return "redirect:/bulletins/list";
            }

            boolean deleted = bulletinBoardService.deleteBulletin(id);
            if (deleted) {
                redirectAttributes.addFlashAttribute("success",
                        "公告「" + bulletin.getTitle() + "」刪除成功！");
            } else {
                redirectAttributes.addFlashAttribute("error", "刪除公告失敗");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "刪除公告失敗: " + e.getMessage());
        }

        return "redirect:/bulletins/list";
    }

    /**
     * 下載附件
     */
    @GetMapping("/download/{filename}")
    public void downloadAttachment(@PathVariable String filename, HttpServletResponse response) {
        try {
            File file = new File("uploads/" + filename);
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 設定回應標頭
            response.setContentType("application/octet-stream");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            // 輸出檔案內容
            try (FileInputStream inputStream = new FileInputStream(file);
                    OutputStream outputStream = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * AJAX 刪除公告（返回 JSON）
     */
    @DeleteMapping("/api/delete/{id}")
    @ResponseBody
    public String deleteBulletinAjax(@PathVariable Integer id) {
        try {
            boolean deleted = bulletinBoardService.deleteBulletin(id);
            if (deleted) {
                return "{\"success\": true, \"message\": \"刪除成功\"}";
            } else {
                return "{\"success\": false, \"message\": \"刪除失敗\"}";
            }
        } catch (Exception e) {
            return "{\"success\": false, \"message\": \"" + e.getMessage() + "\"}";
        }
    }
}
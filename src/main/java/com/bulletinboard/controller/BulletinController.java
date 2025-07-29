package com.bulletinboard.controller;

import com.bulletinboard.model.Bulletin;
import com.bulletinboard.service.BulletinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/bulletins")
public class BulletinController {
    
    @Autowired
    private BulletinService bulletinService;
    
    private static final int PAGE_SIZE = 10;
    
    /**
     * 公告列表頁面（支援分頁）
     */
    @GetMapping("/list")
    public String listBulletins(@RequestParam(defaultValue = "1") int page,
                               @RequestParam(required = false) String search,
                               Model model) {
        try {
            List<Bulletin> bulletins;
            int totalPages;
            long totalCount;
            
            if (search != null && !search.trim().isEmpty()) {
                bulletins = bulletinService.searchBulletinsByTitle(search.trim());
                totalCount = bulletins.size();
                totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
                
                // 手動分頁
                int startIndex = (page - 1) * PAGE_SIZE;
                int endIndex = Math.min(startIndex + PAGE_SIZE, bulletins.size());
                if (startIndex < bulletins.size()) {
                    bulletins = bulletins.subList(startIndex, endIndex);
                } else {
                    bulletins.clear();
                }
            } else {
                bulletins = bulletinService.getBulletinsByPage(page, PAGE_SIZE);
                totalPages = bulletinService.getTotalPages(PAGE_SIZE);
                totalCount = bulletinService.getTotalCount();
            }
            
            model.addAttribute("bulletins", bulletins);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("search", search);
            
            return "bulletin/list";
        } catch (Exception e) {
            model.addAttribute("error", "載入公告列表失敗: " + e.getMessage());
            return "bulletin/list";
        }
    }
    
    /**
     * 顯示新增公告表單
     */
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("bulletin", new Bulletin());
        return "bulletin/form";
    }
    
    /**
     * 處理新增公告
     */
    @PostMapping
    public String createBulletin(@ModelAttribute Bulletin bulletin,
                                BindingResult bindingResult,
                                @RequestParam(value = "attachmentFile", required = false) MultipartFile attachmentFile,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            return "bulletin/form";
        }
        
        try {
            bulletinService.createBulletin(bulletin, attachmentFile);
            redirectAttributes.addFlashAttribute("success", "公告創建成功！");
            return "redirect:/bulletins/list";
        } catch (Exception e) {
            model.addAttribute("error", "創建公告失敗: " + e.getMessage());
            return "bulletin/form";
        }
    }
    
    /**
     * 顯示公告詳情
     */
    @GetMapping("/{id}")
    public String viewBulletin(@PathVariable Long id, Model model) {
        try {
            Bulletin bulletin = bulletinService.getBulletinById(id);
            if (bulletin == null) {
                model.addAttribute("error", "找不到指定的公告");
                return "error/404";
            }
            model.addAttribute("bulletin", bulletin);
            return "bulletin/view";
        } catch (Exception e) {
            model.addAttribute("error", "載入公告失敗: " + e.getMessage());
            return "error/500";
        }
    }
    
    /**
     * 顯示編輯公告表單
     */
    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model) {
        try {
            Bulletin bulletin = bulletinService.getBulletinById(id);
            if (bulletin == null) {
                model.addAttribute("error", "找不到指定的公告");
                return "error/404";
            }
            model.addAttribute("bulletin", bulletin);
            return "bulletin/form";
        } catch (Exception e) {
            model.addAttribute("error", "載入公告失敗: " + e.getMessage());
            return "error/500";
        }
    }
    
    /**
     * 處理更新公告
     */
    @PostMapping("/{id}")
    public String updateBulletin(@PathVariable Long id,
                                @ModelAttribute Bulletin bulletin,
                                BindingResult bindingResult,
                                @RequestParam(value = "attachmentFile", required = false) MultipartFile attachmentFile,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        bulletin.setId(id);
        
        if (bindingResult.hasErrors()) {
            return "bulletin/form";
        }
        
        try {
            bulletinService.updateBulletin(bulletin, attachmentFile);
            redirectAttributes.addFlashAttribute("success", "公告更新成功！");
            return "redirect:/bulletins/list";
        } catch (Exception e) {
            model.addAttribute("error", "更新公告失敗: " + e.getMessage());
            return "bulletin/form";
        }
    }
    
    /**
     * 刪除公告
     */
    @PostMapping("/{id}/delete")
    public String deleteBulletin(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            bulletinService.deleteBulletin(id);
            redirectAttributes.addFlashAttribute("success", "公告刪除成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "刪除公告失敗: " + e.getMessage());
        }
        return "redirect:/bulletins/list";
    }
}
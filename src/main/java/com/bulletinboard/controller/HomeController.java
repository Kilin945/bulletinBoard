package com.bulletinboard.controller;

import com.bulletinboard.model.BulletinBoard;
import com.bulletinboard.service.BulletinBoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

/**
 * 首頁控制器
 * 處理網站首頁和根路徑請求
 */
@Controller
public class HomeController {

    @Autowired
    private BulletinBoardService bulletinBoardService;

    /**
     * 網站根路徑 - 重定向到公告列表
     */
    @GetMapping("/")
    public String home() {
        return "redirect:/bulletins/list";
    }

    /**
     * 測試頁面 - 不需要資料庫
     */
    @GetMapping("/test")
    public String test(Model model) {
        model.addAttribute("message", "應用程式運行正常！");
        return "test";
    }

    /**
     * 資料庫測試頁面
     */
    @GetMapping("/dbtest")
    public String dbTest(Model model) {
        try {
            long totalBulletins = bulletinBoardService.getTotalBulletins();
            model.addAttribute("message", "資料庫連線成功！總共有 " + totalBulletins + " 筆公告");
            model.addAttribute("success", true);
        } catch (Exception e) {
            model.addAttribute("message", "資料庫連線失敗：" + e.getMessage());
            model.addAttribute("success", false);
            model.addAttribute("error", e.getClass().getSimpleName());
            e.printStackTrace(); // 這會在終端機輸出完整的錯誤堆疊
        }
        return "test";
    }

    /**
     * 首頁 - 顯示最新有效公告
     */
    @GetMapping("/index")
    public String index(Model model) {
        try {
            // 取得最新的有效公告
            List<BulletinBoard> validBulletins = bulletinBoardService.getValidBulletins();
            model.addAttribute("bulletins", validBulletins);
            model.addAttribute("totalBulletins", bulletinBoardService.getTotalBulletins());
            return "index";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "載入首頁資料失敗: " + e.getMessage());
            return "error/500";
        }
    }

    /**
     * 關於頁面
     */
    @GetMapping("/about")
    public String about() {
        return "about";
    }
}
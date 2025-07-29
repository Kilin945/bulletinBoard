package com.bulletinboard.controller;

import com.bulletinboard.service.BulletinService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    
    @Autowired
    private BulletinService bulletinService;
    
    @GetMapping("/")
    public String home(Model model) {
        try {
            // 獲取最新的5條有效公告
            var validBulletins = bulletinService.getValidBulletins();
            var recentBulletins = validBulletins.size() > 5 ? 
                validBulletins.subList(0, 5) : validBulletins;
            
            model.addAttribute("recentBulletins", recentBulletins);
            model.addAttribute("totalCount", bulletinService.getTotalCount());
            
            return "index";
        } catch (Exception e) {
            model.addAttribute("error", "載入首頁失敗: " + e.getMessage());
            return "index";
        }
    }
}
package com.agriconnect.controller;

import com.agriconnect.model.MspRate;
import com.agriconnect.service.MspRateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class MspController {

    @Autowired
    private MspRateService mspService;

    @GetMapping("/web/msp-checker")
    public String mspChecker(Model model) {
        model.addAttribute("rates", mspService.getAllRates());
        return "msp-checker";
    }

    @GetMapping("/api/msp")
    @ResponseBody
    public ResponseEntity<MspRate> getMspForCrop(@RequestParam String crop) {
        MspRate rate = mspService.getCurrentMsp(crop);
        if (rate == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(rate);
    }
}

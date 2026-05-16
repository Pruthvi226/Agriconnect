package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.SupplyChainTraceView;
import com.agriconnect.service.SupplyChainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class SupplyChainController {

    @Autowired
    private SupplyChainService supplyChainService;

    @GetMapping("/chain/{token}")
    public ModelAndView viewSupplyChainTrace(@PathVariable String token) {
        ModelAndView mav = new ModelAndView("public/supply-chain");
        mav.addObject("trace", supplyChainService.resolveSupplyChainTrace(token));
        return mav;
    }

    @GetMapping(value = "/qr/{fileName:.+}", produces = MediaType.IMAGE_PNG_VALUE)
    @ResponseBody
    public byte[] viewQrImage(@PathVariable String fileName) {
        return supplyChainService.getQrImageBytes(fileName);
    }
}

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/api/v1/orders")
class SupplyChainAdminController {

    @Autowired
    private SupplyChainService supplyChainService;

    @GetMapping("/{id}/qr-download")
    public ResponseEntity<byte[]> downloadQrImage(@PathVariable Long id) {
        byte[] pngBytes = supplyChainService.getQrImageBytesForOrder(id);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_PNG);
        headers.setContentDisposition(ContentDisposition.attachment().filename("order-" + id + "-trace.png").build());
        return ResponseEntity.ok().headers(headers).body(pngBytes);
    }

    @GetMapping("/{id}/supply-chain")
    public ResponseEntity<ApiResponse<SupplyChainTraceView>> getSupplyChainDetails(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(
                supplyChainService.getTraceViewForOrder(id),
                "Supply chain details retrieved"
        ));
    }
}

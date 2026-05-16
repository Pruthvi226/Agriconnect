package com.agriconnect.dto;

import jakarta.validation.constraints.NotBlank;

public class SessionLinkDto {

    @NotBlank
    private String sessionLink;

    public String getSessionLink() { return sessionLink; }
    public void setSessionLink(String sessionLink) { this.sessionLink = sessionLink; }
}

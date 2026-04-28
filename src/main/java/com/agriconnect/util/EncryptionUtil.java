package com.agriconnect.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class EncryptionUtil {

    private static final String AES_ALGORITHM = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128;
    private static final int GCM_IV_LENGTH = 12;

    private static SecretKey getSecretKey() {
        String envKey = System.getenv("AES_SECRET_KEY");
        if (envKey == null || envKey.isBlank()) {
            // Dummy fallback for local dev. IN PRODUCTION, NEVER DO THIS.
            envKey = "12345678901234567890123456789012";
        }
        return new SecretKeySpec(envKey.getBytes(), "AES");
    }

    public static String encryptBankDetails(String plainText) throws Exception {
        if (plainText == null) return null;
        
        byte[] iv = new byte[GCM_IV_LENGTH];
        new SecureRandom().nextBytes(iv);
        
        Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.ENCRYPT_MODE, getSecretKey(), gcmParameterSpec);
        
        byte[] cipherText = cipher.doFinal(plainText.getBytes());
        
        // Prepend IV to ciphertext for decryption
        byte[] cipherTextWithIv = new byte[GCM_IV_LENGTH + cipherText.length];
        System.arraycopy(iv, 0, cipherTextWithIv, 0, GCM_IV_LENGTH);
        System.arraycopy(cipherText, 0, cipherTextWithIv, GCM_IV_LENGTH, cipherText.length);
        
        return Base64.getEncoder().encodeToString(cipherTextWithIv);
    }

    public static String decryptBankDetails(String encryptedText) throws Exception {
        if (encryptedText == null) return null;
        
        byte[] cipherTextWithIv = Base64.getDecoder().decode(encryptedText);
        
        byte[] iv = new byte[GCM_IV_LENGTH];
        System.arraycopy(cipherTextWithIv, 0, iv, 0, GCM_IV_LENGTH);
        
        byte[] cipherText = new byte[cipherTextWithIv.length - GCM_IV_LENGTH];
        System.arraycopy(cipherTextWithIv, GCM_IV_LENGTH, cipherText, 0, cipherText.length);
        
        Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
        GCMParameterSpec gcmParameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.DECRYPT_MODE, getSecretKey(), gcmParameterSpec);
        
        return new String(cipher.doFinal(cipherText));
    }

    public static String hashAadhaar(String plainAadhaar) {
        if (plainAadhaar == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(plainAadhaar.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(2 * encodedhash.length);
            for (int i = 0; i < encodedhash.length; i++) {
                String hex = Integer.toHexString(0xff & encodedhash[i]);
                if(hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing Aadhaar", e);
        }
    }

    public static String maskPhone(String phone) {
        if (phone == null || phone.length() < 4) return phone;
        String lastFour = phone.substring(phone.length() - 4);
        return "******" + lastFour;
    }
}

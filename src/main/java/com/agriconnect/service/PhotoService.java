package com.agriconnect.service;

import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.model.ProduceListing;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class PhotoService {

    @Autowired
    private ProduceListingDao listingDao;

    private final String uploadDir = "uploads/listings/";

    public String save(Long listingId, MultipartFile file) throws IOException {
        if (file.isEmpty()) throw new IllegalArgumentException("File is empty");
        if (file.getSize() > 2 * 1024 * 1024) throw new IllegalArgumentException("File size exceeds 2MB");

        String filename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path path = Paths.get(uploadDir + listingId + "/" + filename);
        
        Files.createDirectories(path.getParent());
        Files.copy(file.getInputStream(), path);

        updateListingPhotos(listingId, filename);
        return filename;
    }

    private void updateListingPhotos(Long listingId, String filename) {
        ProduceListing listing = listingDao.findById(listingId)
                .orElseThrow(() -> new RuntimeException("Listing not found"));
        
        String photosJson = listing.getPhotos();
        List<String> photoList = new ArrayList<>();
        
        // Simple JSON parsing/handling (since we are not using a heavy library here for simplicity)
        if (photosJson != null && photosJson.startsWith("[")) {
            // Very basic extraction for demo
            String content = photosJson.substring(1, photosJson.length() - 1);
            if (!content.isEmpty()) {
                for (String p : content.split(",")) {
                    photoList.add(p.replace("\"", "").trim());
                }
            }
        }
        
        photoList.add(filename);
        
        // Rebuild JSON
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < photoList.size(); i++) {
            sb.append("\"").append(photoList.get(i)).append("\"");
            if (i < photoList.size() - 1) sb.append(",");
        }
        sb.append("]");
        
        listing.setPhotos(sb.toString());
        listingDao.update(listing);
    }
}

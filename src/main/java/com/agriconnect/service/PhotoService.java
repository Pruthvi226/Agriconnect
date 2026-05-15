package com.agriconnect.service;

import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.model.ProduceListing;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class PhotoService {

    @Autowired
    private ProduceListingDao listingDao;

    @Autowired
    private ObjectMapper objectMapper;

    private final Path uploadDir = Paths.get("uploads", "listings");

    public String save(Long listingId, MultipartFile file) throws IOException {
        return saveInternal(listingId, null, file);
    }

    public String saveForUser(Long listingId, Long farmerUserId, MultipartFile file) throws IOException {
        return saveInternal(listingId, farmerUserId, file);
    }

    public List<String> getPhotoPaths(ProduceListing listing) {
        if (listing == null) {
            return List.of();
        }
        return readPhotoList(listing.getPhotos());
    }

    private String saveInternal(Long listingId, Long farmerUserId, MultipartFile file) throws IOException {
        if (file.isEmpty()) throw new IllegalArgumentException("File is empty");
        if (file.getSize() > 2 * 1024 * 1024) throw new IllegalArgumentException("File size exceeds 2MB");
        if (file.getContentType() == null || !file.getContentType().toLowerCase().startsWith("image/")) {
            throw new IllegalArgumentException("Only image uploads are allowed");
        }

        ProduceListing listing = listingDao.findById(listingId)
                .orElseThrow(() -> new IllegalArgumentException("Listing not found"));
        if (farmerUserId != null && !listing.getFarmerProfile().getUser().getId().equals(farmerUserId)) {
            throw new IllegalArgumentException("You can upload photos only for your own listings");
        }

        List<String> photoList = readPhotoList(listing.getPhotos());
        if (photoList.size() >= 3) {
            throw new IllegalArgumentException("You can upload up to 3 photos per listing");
        }

        String originalName = StringUtils.cleanPath(file.getOriginalFilename() == null ? "photo" : file.getOriginalFilename());
        if (originalName.contains("..")) {
            throw new IllegalArgumentException("Invalid file name");
        }
        String safeName = originalName.replaceAll("[^A-Za-z0-9._-]", "_");
        String filename = UUID.randomUUID() + "_" + safeName;
        Path path = uploadDir.resolve(String.valueOf(listingId)).resolve(filename);
        
        Files.createDirectories(path.getParent());
        Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);

        String storedPath = "listings/" + listingId + "/" + filename;
        photoList.add(storedPath);
        listing.setPhotos(objectMapper.writeValueAsString(photoList));
        listingDao.update(listing);
        return storedPath;
    }

    private List<String> readPhotoList(String photosJson) {
        if (photosJson == null || photosJson.isBlank()) {
            return new ArrayList<>();
        }
        try {
            return new ArrayList<>(objectMapper.readValue(photosJson, new TypeReference<List<String>>() {}));
        } catch (IOException ex) {
            return new ArrayList<>();
        }
    }
}

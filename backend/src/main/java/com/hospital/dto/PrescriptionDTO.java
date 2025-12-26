package com.hospital.dto;

import lombok.Data;
import java.util.List;

@Data
public class PrescriptionDTO {
    private Integer visId;
    private List<PrescriptionItemDTO> items;

    @Data
    public static class PrescriptionItemDTO {
        private Integer drugId;
        private Integer quantity;
    }
}

package com.bulletinboard.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Component
public class StringToLocalDateConverter implements Converter<String, LocalDate> {
    
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Override
    public LocalDate convert(String source) {
        if (source == null || source.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(source.trim(), FORMATTER);
        } catch (Exception e) {
            throw new IllegalArgumentException("無法解析日期: " + source, e);
        }
    }
}
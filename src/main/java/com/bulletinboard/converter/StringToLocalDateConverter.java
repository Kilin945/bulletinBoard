package com.bulletinboard.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * String 到 LocalDate 的轉換器
 * 用於處理前端表單傳遞的日期字串轉換為 LocalDate 類型
 */
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
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("無法解析日期格式: " + source + "，期望格式: yyyy-MM-dd", e);
        }
    }
}
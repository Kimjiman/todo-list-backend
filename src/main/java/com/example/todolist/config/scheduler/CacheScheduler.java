package com.example.todolist.config.scheduler;

import com.example.todolist.module.code.service.CodeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@RequiredArgsConstructor
public class CacheScheduler {
    private final CodeService codeService;

    @Scheduled(cron = "${cron.cache.refresh-code}")
    public void refreshCodeCache() {
        codeService.refreshCache();
    }
}

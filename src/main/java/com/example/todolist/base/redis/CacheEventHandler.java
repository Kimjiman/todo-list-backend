package com.example.todolist.base.redis;

import com.example.todolist.base.constants.CacheType;

public interface CacheEventHandler {

    CacheType getSupportedCacheType();

    void handle();
}

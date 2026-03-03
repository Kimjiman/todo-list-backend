package com.example.todolist.module.code.repository;

import com.example.todolist.module.code.entity.CodeGroup;
import com.example.todolist.module.code.model.CodeGroupSearchParam;

import java.util.List;

public interface CodeGroupRepositoryCustom {
    List<CodeGroup> findAllBy(CodeGroupSearchParam param);
    String findMaxCodeGroup();
}

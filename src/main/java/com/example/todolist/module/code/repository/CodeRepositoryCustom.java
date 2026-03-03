package com.example.todolist.module.code.repository;

import com.example.todolist.module.code.entity.Code;
import com.example.todolist.module.code.model.CodeSearchParam;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface CodeRepositoryCustom {
    List<Code> findAllBy(CodeSearchParam param);
    Page<Code> findAllBy(CodeSearchParam param, Pageable pageable);
    String findMaxCodeByCodeGroupId(Long codeGroupId);
}

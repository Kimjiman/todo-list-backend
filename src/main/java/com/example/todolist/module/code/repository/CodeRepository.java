package com.example.todolist.module.code.repository;

import com.example.todolist.module.code.entity.Code;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CodeRepository extends JpaRepository<Code, Long>, CodeRepositoryCustom {
    void deleteByCodeGroupId(Long codeGroupId);
}

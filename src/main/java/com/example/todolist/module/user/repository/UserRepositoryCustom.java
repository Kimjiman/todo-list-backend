package com.example.todolist.module.user.repository;

import com.example.todolist.module.user.entity.User;
import com.example.todolist.module.user.model.UserSearchParam;

import java.util.List;

public interface UserRepositoryCustom {
    List<User> findAllBy(UserSearchParam param);
}

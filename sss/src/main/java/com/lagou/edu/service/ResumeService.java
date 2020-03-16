package com.lagou.edu.service;

import com.lagou.edu.pojo.Resume;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Chenyuhua
 * @date 2020/3/16 4:04
 */

@Service
public interface ResumeService {
    List<Resume> queryAccountList();

    Resume queryById(Long id);

    Resume save(Resume resume);

    void delete(Long id);
}

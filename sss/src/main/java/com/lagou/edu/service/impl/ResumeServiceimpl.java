package com.lagou.edu.service.impl;

import com.lagou.edu.dao.ResumeDao;
import com.lagou.edu.pojo.Resume;
import com.lagou.edu.service.ResumeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * @author Chenyuhua
 * @date 2020/3/16 4:04
 */
@Service
public class ResumeServiceimpl implements ResumeService {

    @Autowired
    private ResumeDao resumeDao;

    @Override
    public Resume save(Resume resume) {
        return resumeDao.save(resume);
    }

    @Override
    public void delete(Long id) {
        resumeDao.deleteById(id);
    }

    @Override
    public Resume queryById(Long id) {
        Optional<Resume> byId = resumeDao.findById(id);
        Resume resume = byId.orElse(new Resume());
        return resume;
    }

    @Override
    public List<Resume> queryAccountList() {
        return resumeDao.findAll();
    }
}

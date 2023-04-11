package com.project.zoopiter.domain.member.svc;

import com.project.zoopiter.domain.entity.Member;
import com.project.zoopiter.domain.member.dao.MemberDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class MemberSVCImpl implements MemberSVC {

  private final MemberDAO memberDAO;

  /**
   * 가입
   *
   * @param member 회원정보
   * @return
   */
  @Override
  public Member save(Member member) {
    return memberDAO.save(member);
  }

  /**
   * @param member 회원정보
   * @return
   */
  @Override
  public Member save2(Member member) {
    return memberDAO.save2(member);
  }

  /**
   * 회원정보수정
   *
   * @param userId 아이디
   * @param member 회원정보
   */
  @Override
  public void update(String userId, Member member) {

  }

  /**
   * 조회 by email
   *
   * @param userEmail 이메일
   * @return
   */
  @Override
  public Optional<Member> findbyEmail(String userEmail) {
    return Optional.empty();
  }

  /**
   * 조회 by user_id
   *
   * @param userId 아이디
   * @return
   */
  @Override
  public Optional<Member> findById(String userId) {
    return Optional.empty();
  }

  /**
   * 전체 조회
   *
   * @return
   */
  @Override
  public List<Member> findAll() {
    return null;
  }

  /**
   * 탈퇴
   *
   * @param userId 아이디
   */
  @Override
  public void delete(String userId) {

  }

  /**
   * @param userEmail 이메일
   * @return
   */
  @Override
  public boolean isExistEmail(String userEmail) {
    return memberDAO.isExistEmail(userEmail);
  }

  /**
   * @param userId 아이디
   * @return
   */
  @Override
  public boolean isExistId(String userId) {
    return memberDAO.isExistId(userId);
  }

  /**
   * @param userNick 닉네임
   * @return
   */
  @Override
  public boolean isExistNick(String userNick) {
    return memberDAO.isExistNick(userNick);
  }

  /**
   * 로그인
   *
   * @param userId 아이디
   * @param userPw 비밀번호
   * @return
   */
  @Override
  public Optional<Member> login(String userId, String userPw) {
    return memberDAO.login(userId,userPw);
  }

  /**
   * 아이디 찾기
   *
   * @param userEmail 이메일
   * @return
   */
  @Override
  public Optional<String> findIdByEmail(String userEmail) {
    return Optional.empty();
  }

  /**
   * 비밀번호 찾기
   *
   * @param userEmail 이메일
   * @param userId    아이디
   * @return
   */
  @Override
  public boolean isExistByEmailAndId(String userEmail, String userId) {
    return memberDAO.isExistByEmailAndId(userEmail,userId);
  }
}
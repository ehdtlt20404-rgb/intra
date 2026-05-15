package service;

import java.util.List;
import java.util.Map;

/**
 * WardenService
 * 기관장 실적·성과 관리시스템 통합 Service 인터페이스
 */
public interface WardenService {

    // =========================================================
    // 리더십 - 범주
    // =========================================================

    /** 범주 + 중점과제 목록 조회 */
    List<Map<String, Object>> getCategoryList();

    /** 범주 저장 */
    int saveCategory(String title, String dept);

    /** 범주 삭제 */
    int deleteCategory(String catId);

    // =========================================================
    // 리더십 - 중점과제
    // =========================================================

    /** 중점과제 상세 조회 */
    Map<String, Object> getTaskDetail(String catId, String taskId);

    /** 중점과제 저장 */
    int saveTask(String catId, String title);

    /** 중점과제 삭제 */
    int deleteTask(String catId, String taskId);

    /** 중점과제 상세(월별 계획/실적 포함) 저장 */
    int saveTaskDetail(Map<String, Object> param);

    // =========================================================
    // 경영계약 - 성과목표
    // =========================================================

    /** 성과목표 + 성과지표 목록 조회 */
    List<Map<String, Object>> getContractGoals();

    /** 성과목표 저장 */
    int saveContractGoal(String title);

    /** 성과목표 삭제 */
    int deleteContractGoal(String goalId);

    // =========================================================
    // 경영계약 - 성과지표
    // =========================================================

    /** 성과지표 상세 조회 */
    Map<String, Object> getIndicatorDetail(String goalId, String indId, String sub);

    /** 성과지표 저장 */
    int saveContractIndicator(Map<String, Object> param);

    /** 성과지표 삭제 */
    int deleteContractIndicator(String goalId, String indId);

    /** 성과지표 상세(달성계획/월별) 저장 */
    int saveIndicatorDetail(Map<String, Object> param);

    // =========================================================
    // 기타 주요 활동 / 기관장 활동내역
    // =========================================================

    /**
     * 활동 목록 조회
     * @param category "etc"(기타), "all"(전체), "leadership", "contract"
     */
    List<Map<String, Object>> getActivities(String category);

    /** 활동 단건 상세 조회 */
    Map<String, Object> getActivityDetail(String actId);

    /**
     * 연관 지표 드롭다운 옵션 목록
     * @return { "leadership": [...], "contract": [...] }
     */
    Map<String, Object> getIndicatorOptions();

    /** 활동 저장 */
    int saveActivity(Map<String, Object> param);

    /** 활동 수정 */
    int updateActivity(Map<String, Object> param);

    /** 활동 삭제 */
    int deleteActivity(String actId);
}

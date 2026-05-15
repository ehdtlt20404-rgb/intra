package mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * WardenMapper
 * 기관장 실적·성과 관리시스템 통합 MyBatis Mapper 인터페이스
 *
 * ▶ DB 연결 후 resources/mapper/WardenMapper.xml 과 매핑됩니다.
 */
@Mapper
public interface WardenMapper {

    // =========================================================
    // 리더십 - 범주
    // =========================================================

    /** 범주 + 중점과제 목록 조회 */
    List<Map<String, Object>> selectCategoryList();

    /** 범주 단건 조회 */
    Map<String, Object> selectCategory(@Param("catId") String catId);

    /** 범주 저장 */
    int insertCategory(@Param("title") String title, @Param("dept") String dept);

    /** 범주 삭제 */
    int deleteCategory(@Param("catId") String catId);

    // =========================================================
    // 리더십 - 중점과제
    // =========================================================

    /** 중점과제 목록 조회 (범주별) */
    List<Map<String, Object>> selectTaskList(@Param("catId") String catId);

    /** 중점과제 단건 조회 */
    Map<String, Object> selectTask(@Param("catId") String catId, @Param("taskId") String taskId);

    /** 중점과제 순번 조회 */
    int selectTaskIndex(@Param("catId") String catId, @Param("taskId") String taskId);

    /** 중점과제 저장 */
    int insertTask(@Param("catId") String catId, @Param("title") String title);

    /** 중점과제 삭제 */
    int deleteTask(@Param("catId") String catId, @Param("taskId") String taskId);

    /** 중점과제 상세 존재 여부 */
    int selectTaskDetailCount(Map<String, Object> param);

    /** 중점과제 상세 조회 */
    Map<String, Object> selectTaskDetail(@Param("taskId") String taskId);

    /** 중점과제 상세 저장 */
    int insertTaskDetail(Map<String, Object> param);

    /** 중점과제 상세 수정 */
    int updateTaskDetail(Map<String, Object> param);

    /** 중점과제 월별 계획/실적 조회 */
    List<Map<String, Object>> selectTaskMonths(@Param("taskId") String taskId);

    /** 중점과제 월별 계획/실적 전체 삭제 */
    int deleteTaskMonths(@Param("taskId") String taskId);

    /** 중점과제 월별 계획/실적 저장 */
    int insertTaskMonth(Map<String, Object> param);

    // =========================================================
    // 경영계약 - 성과목표
    // =========================================================

    /** 성과목표 목록 조회 */
    List<Map<String, Object>> selectContractGoalList();

    /** 성과목표 단건 조회 */
    Map<String, Object> selectContractGoal(@Param("goalId") String goalId);

    /** 성과목표 저장 */
    int insertContractGoal(@Param("title") String title);

    /** 성과목표 삭제 */
    int deleteContractGoal(@Param("goalId") String goalId);

    // =========================================================
    // 경영계약 - 성과지표
    // =========================================================

    /** 성과지표 목록 조회 (성과목표 하위) */
    List<Map<String, Object>> selectIndicatorList(@Param("goalId") String goalId);

    /** 성과지표 단건 조회 */
    Map<String, Object> selectIndicator(@Param("indId") String indId);

    /** 성과지표 저장 */
    int insertContractIndicator(Map<String, Object> param);

    /** 성과지표 삭제 */
    int deleteContractIndicator(@Param("indId") String indId);

    /** 성과목표 하위 성과지표 전체 삭제 */
    int deleteIndicatorByGoalId(@Param("goalId") String goalId);

    /** 세부과제 조회 */
    Map<String, Object> selectSubTask(@Param("subTaskId") String subTaskId);

    /** 세부과제 삭제 (성과지표 하위 전체) */
    int deleteSubTaskByIndId(@Param("indId") String indId);

    /** 성과지표 상세 존재 여부 */
    int selectIndicatorDetailCount(Map<String, Object> param);

    /** 성과지표 상세 조회 */
    Map<String, Object> selectIndicatorDetail(@Param("indId") String indId);

    /** 성과지표 상세 저장 */
    int insertIndicatorDetail(Map<String, Object> param);

    /** 성과지표 상세 수정 */
    int updateIndicatorDetail(Map<String, Object> param);

    /** 성과지표 상세 삭제 */
    int deleteIndicatorDetail(@Param("indId") String indId);

    /** 성과지표 월별 계획/실적 조회 */
    List<Map<String, Object>> selectIndicatorMonths(@Param("indId") String indId);

    /** 성과지표 월별 계획/실적 전체 삭제 */
    int deleteIndicatorMonths(@Param("indId") String indId);

    /** 성과지표 월별 계획/실적 저장 */
    int insertIndicatorMonth(Map<String, Object> param);

    // =========================================================
    // 기타 주요 활동 / 기관장 활동내역
    // =========================================================

    /** 전체 활동 목록 조회 */
    List<Map<String, Object>> selectAllActivities();

    /** 카테고리별 활동 목록 조회 */
    List<Map<String, Object>> selectActivitiesByCategory(@Param("category") String category);

    /** 활동 단건 조회 */
    Map<String, Object> selectActivity(@Param("actId") String actId);

    /** 리더십 연관지표 옵션 목록 */
    List<Map<String, Object>> selectLeadershipOptions();

    /** 경영계약 연관지표 옵션 목록 */
    List<Map<String, Object>> selectContractOptions();

    /** 활동 저장 */
    int insertActivity(Map<String, Object> param);

    /** 활동 수정 */
    int updateActivity(Map<String, Object> param);

    /** 활동 삭제 */
    int deleteActivity(@Param("actId") String actId);

    /** 활동 연관지표 조회 */
    List<Map<String, Object>> selectActivityIndicators(@Param("actId") String actId);

    /** 활동 연관지표 저장 */
    int insertActivityIndicator(Map<String, Object> param);

    /** 활동 연관지표 전체 삭제 */
    int deleteActivityIndicators(@Param("actId") String actId);
}

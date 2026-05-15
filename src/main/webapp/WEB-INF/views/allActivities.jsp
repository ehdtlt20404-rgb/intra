<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="기관장 활동내역"/>
<c:set var="activeMenu" value="activities"/>
<%@ include file="/WEB-INF/views/include/header.jsp"%>

        <div class="page page--activities">
          <section class="activities-panel aa-page" aria-labelledby="all-activities-heading">
            <h2 id="all-activities-heading" class="all-activities__title">기관장 활동내역</h2>

            <!-- KPI 요약 카드 -->
            <div class="aa-summary" aria-label="활동 요약 지표">
              <div class="aa-kpi"><span class="aa-kpi__label">총 활동</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-total">0</strong><span class="aa-kpi__unit">건</span></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">이번 달</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-month">0</strong><span class="aa-kpi__unit" id="aa-kpi-month-delta">건</span></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">증빙 보유율</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value" id="aa-kpi-proof">0<small>%</small></strong></div></div>
              <div class="aa-kpi"><span class="aa-kpi__label">최근 활동</span><div class="aa-kpi__value-row"><strong class="aa-kpi__value aa-kpi__value--date" id="aa-kpi-last">-</strong></div></div>
            </div>

            <!-- 차트 영역 -->
            <div class="aa-charts">
              <div class="aa-chart-card">
                <h3 class="aa-chart-card__title">활동유형 분포</h3>
                <p class="aa-chart-card__hint">조각·범례를 클릭하면 해당 유형으로 필터링되고, 다시 클릭하면 전체로 돌아옵니다.</p>
                <div class="aa-donut-wrap" id="aa-chart-type" role="list"></div>
              </div>
              <div class="aa-chart-card">
                <h3 class="aa-chart-card__title">월별 활동 타임라인</h3>
                <p class="aa-chart-card__hint">막대를 클릭하면 해당 월로 필터링되고, 다시 클릭하면 전체로 돌아옵니다.</p>
                <div class="aa-stack" id="aa-chart-month"></div>
                <div class="aa-stack-legend" aria-hidden="true">
                  <span class="aa-stack-legend__item"><i class="aa-stack-legend__swatch aa-stack-legend__swatch--leadership"></i>리더십</span>
                  <span class="aa-stack-legend__item"><i class="aa-stack-legend__swatch aa-stack-legend__swatch--contract"></i>경영계약</span>
                  <span class="aa-stack-legend__item"><i class="aa-stack-legend__swatch aa-stack-legend__swatch--etc"></i>기타</span>
                </div>
              </div>
            </div>

            <!-- 필터 -->
            <div class="activities-toolbar all-activities__toolbar aa-toolbar">
              <div class="all-activities__filter" role="tablist" aria-label="구분 필터">
                <button type="button" class="all-activities__filter-btn is-active" data-filter="all"        onclick="setCategory('all')">전체</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="leadership" onclick="setCategory('leadership')">리더십</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="contract"   onclick="setCategory('contract')">경영계약</button>
                <button type="button" class="all-activities__filter-btn"           data-filter="etc"        onclick="setCategory('etc')">기타 주요 활동</button>
              </div>
              <div class="aa-filters">
                <label class="aa-filter"><span class="aa-filter__label">활동유형</span>
                  <select id="aa-filter-type" class="aa-filter__select">
                    <option value="">전체</option>
                    <option value="direction">방향제시</option>
                    <option value="resource">자원배분</option>
                    <option value="communication">소통협력</option>
                    <option value="execution">실행강화</option>
                    <option value="problem">문제해결</option>
                  </select>
                </label>
                <label class="aa-filter"><span class="aa-filter__label">기간</span>
                  <select id="aa-filter-period" class="aa-filter__select">
                    <option value="all">전체</option>
                    <option value="1m">최근 1개월</option>
                    <option value="3m">최근 3개월</option>
                    <option value="6m">최근 6개월</option>
                    <option value="ytd">올해</option>
                  </select>
                </label>
                <label class="aa-filter"><span class="aa-filter__label">월</span>
                  <select id="aa-filter-month" class="aa-filter__select">
                    <option value="">전체</option>
                  </select>
                </label>
                <label class="aa-filter aa-filter--search"><span class="aa-filter__label visually-hidden">검색</span>
                  <input type="search" id="aa-filter-search" class="aa-filter__input" placeholder="제목·내용·지표 검색">
                </label>
                <button type="button" class="aa-filter-reset" onclick="resetFilter()">초기화</button>
              </div>
            </div>
            <div class="all-activities__count-row">
              <span class="all-activities__count" id="all-activities-count" aria-live="polite"></span>
            </div>

            <!-- 테이블 -->
            <div class="activities-table-wrap">
              <table class="activities-table all-activities__table">
                <colgroup>
                  <col style="width:3.5rem"><col style="width:5.5rem"><col>
                  <col style="width:13rem"><col style="width:7.5rem"><col style="width:5rem">
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col" class="all-activities__col-no">No.</th>
                    <th scope="col">구분</th>
                    <th scope="col">활동내용</th>
                    <th scope="col">활동유형</th>
                    <th scope="col">활동일자</th>
                    <th scope="col">첨부</th>
                  </tr>
                </thead>
                <tbody id="all-activities-tbody">
                  <tr class="activities-table__empty-row"><td colspan="6">데이터를 불러오는 중입니다...</td></tr>
                </tbody>
              </table>
            </div>
            <nav class="result-pagination" id="all-activities-pagination" aria-label="활동내역 페이지"></nav>
          </section>
        </div>

  <!-- 활동 상세 모달 -->
  <div class="lead-modal__backdrop" id="aa-modal" hidden role="dialog" aria-modal="true" aria-labelledby="aa-modal-title">
    <div class="lead-modal lead-modal--wide is-view-mode" role="document">
      <div class="lead-modal__head">
        <h3 class="lead-modal__title" id="aa-modal-title">활동 상세</h3>
        <button type="button" class="lead-modal__x" onclick="closeModal()" aria-label="닫기">×</button>
      </div>
      <div class="lead-modal__body lead-modal__body--activity">
        <div class="aa-modal-meta">
          <div class="aa-modal-meta__row">
            <span class="aa-modal-meta__key">구분</span>
            <span class="aa-modal-meta__val" id="aa-modal-kind-text">—</span>
          </div>
          <div class="aa-modal-meta__row">
            <span class="aa-modal-meta__key">연관 지표</span>
            <span class="aa-modal-meta__val" id="aa-modal-indicator">—</span>
          </div>
        </div>
        <div class="lead-act-modal__field lead-act-modal__field--full">
          <label class="lead-act-modal__label">활동내용명</label>
          <input type="text" id="aa-modal-name" class="lead-modal__input" readonly>
        </div>
        <div class="lead-act-modal__grid2">
          <div class="lead-act-modal__field">
            <label class="lead-act-modal__label">① 인식</label>
            <textarea id="aa-modal-recognition" class="lead-modal__input lead-modal__input--textarea" rows="3" readonly></textarea>
          </div>
          <div class="lead-act-modal__field">
            <label class="lead-act-modal__label">② 방향</label>
            <textarea id="aa-modal-direction" class="lead-modal__input lead-modal__input--textarea" rows="3" readonly></textarea>
          </div>
        </div>
        <div class="lead-act-modal__field lead-act-modal__field--full">
          <label class="lead-act-modal__label">③ 활동유형</label>
          <div class="lead-act-modal__type-grid" id="aa-modal-type-grid"></div>
        </div>
        <div class="lead-act-modal__field lead-act-modal__field--full">
          <label class="lead-act-modal__label">④ 세부 활동실적</label>
          <textarea id="aa-modal-content" class="lead-modal__input lead-modal__input--textarea" rows="4" readonly></textarea>
        </div>
        <div class="lead-act-modal__grid2">
          <div class="lead-act-modal__field">
            <label class="lead-act-modal__label">활동 일자</label>
            <input type="text" id="aa-modal-date" class="lead-modal__input" readonly>
          </div>
          <div class="lead-act-modal__field">
            <label class="lead-act-modal__label">증빙자료</label>
            <input type="text" id="aa-modal-proof" class="lead-modal__input" readonly>
          </div>
        </div>
      </div>
      <div class="lead-modal__foot">
        <button type="button" class="btn btn--secondary" onclick="closeModal()">닫기</button>
        <button type="button" class="btn btn--primary admin-only" onclick="goEdit()">수정하기</button>
      </div>
    </div>
  </div>

  <script>window.CTX = "${pageContext.request.contextPath}";</script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>

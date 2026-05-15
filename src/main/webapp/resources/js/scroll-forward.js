/**
 * Scroll forward helper.
 *
 * `.app-layout` 은 height:100vh + overflow:hidden 으로 묶여 있고, 실제 세로
 * 스크롤은 `.app-main` 내부에서만 일어난다. 이 때문에 사이드바·헤더 양 옆
 * 회색 여백 위에 마우스 커서를 올린 채 휠을 굴리면 아무것도 스크롤되지
 * 않는 UX 문제가 있다. 본 스크립트는 `.app-main` 외부에서 발생한 wheel
 * 이벤트를 가로채 `.app-main` 의 scrollTop 으로 전달한다.
 */
(function () {
  function init() {
    var main = document.querySelector(".app-main");
    if (!main) return;

    document.addEventListener(
      "wheel",
      function (e) {
        /* `.app-main` 내부에서 발생한 휠은 기본 동작에 맡긴다. */
        if (main.contains(e.target)) return;

        /* 모달·드롭다운 등 다른 스크롤 컨테이너 위에서는 가로채지 않는다. */
        var node = e.target instanceof Element ? e.target : null;
        while (node && node !== document.body) {
          var cs = window.getComputedStyle(node);
          var oy = cs.overflowY;
          if ((oy === "auto" || oy === "scroll") && node.scrollHeight > node.clientHeight) {
            return;
          }
          node = node.parentElement;
        }

        main.scrollTop += e.deltaY;
        e.preventDefault();
      },
      { passive: false }
    );
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

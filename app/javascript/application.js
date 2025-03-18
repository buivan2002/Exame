import "@hotwired/turbo-rails"
import "controllers"
document.addEventListener("DOMContentLoaded", function () {
  console.log("JavaScript đã load từ application.js!");
  let timeLeftElement = document.getElementById("exam-timer");

  if (timeLeftElement) {
      let timeLeft = parseInt(timeLeftElement.dataset.timeLeft, 10);

      function updateTimerDisplay() {
          let minutes = Math.floor(timeLeft / 60);
          let seconds = timeLeft % 60;
          timeLeftElement.textContent = `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
      }

      function startTimer() {
          updateTimerDisplay();
          let timerInterval = setInterval(() => {
              timeLeft--;
              updateTimerDisplay();

              if (timeLeft <= 0) {
                  clearInterval(timerInterval);
                  console.log("Hết thời gian!");

                  let examForm = document.getElementById("exam-form");
                  if (examForm) {
                      // ✅ Tạo input ẩn để chỉ định hành động là "Nộp bài"
                      let hiddenSubmit = document.createElement("input");
                      hiddenSubmit.type = "hidden";
                      hiddenSubmit.name = "submit_exam";
                      hiddenSubmit.value = "1"; // Giá trị không quan trọng, chỉ cần có name

                      examForm.appendChild(hiddenSubmit);
                      examForm.submit();
                  } else {
                      console.error("Không tìm thấy form để nộp bài!");
                  }
              }
          }, 1000);
      }

      startTimer();
  }
});
import "./controllers"
import "@rails/ujs";
Rails.start();

//= require rails-ujs
//= require turbolinks
//= require_tree .

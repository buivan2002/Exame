// import { Controller } from "@hotwired/stimulus";

// export default class extends Controller {
//   static targets = ["timer", "form"];

//   connect() {
//     console.log("TimerController đã được load!");
//     debugger;

//     this.timeLeft = parseInt(this.timerTarget.textContent);
//     this.updateTimerDisplay();
//     this.startTimer();
//   }

//   updateTimerDisplay() {
//     let minutes = Math.floor(this.timeLeft / 60);
//     let seconds = this.timeLeft % 60;
//     this.timerTarget.textContent = `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
//   }

//   startTimer() {
//     this.updateTimerDisplay();
//     this.timerInterval = setInterval(() => {
//       this.timeLeft--;
//       this.updateTimerDisplay();

//       if (this.timeLeft <= 0) {
//         clearInterval(this.timerInterval);
//         console.log("Hết thời gian!");
//         this.submitExam();
//       }
//     }, 1000);
//   }

//   submitExam() {
//     this.formTarget.submit(); // Tự động nộp bài khi hết giờ
//   }
// }

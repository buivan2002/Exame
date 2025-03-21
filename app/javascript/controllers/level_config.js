document.addEventListener("DOMContentLoaded", function () {
	document.querySelectorAll(".edit-level-btn").forEach((btn) => {
		btn.addEventListener("click", function () {
			// Lấy dữ liệu từ button
			let levelId = this.dataset.id;
			let level = this.dataset.level;
			let name = this.dataset.name;
			let requiredPoints = this.dataset.required_points;
			let quizReward = this.dataset.quiz_reward;
			let loginReward = this.dataset.login_reward;
			let status = this.dataset.status;

			// Điền dữ liệu vào form chỉnh sửa
			document.querySelector(
				"#edit-level-form input[name='level']"
			).value = level;
			document.querySelector(
				"#edit-level-form input[name='name']"
			).value = name;
			document.querySelector(
				"#edit-level-form input[name='required_points']"
			).value = requiredPoints;
			document.querySelector(
				"#edit-level-form input[name='quiz_reward']"
			).value = quizReward;
			document.querySelector(
				"#edit-level-form input[name='login_reward']"
			).value = loginReward;
			document.querySelector(
				"#edit-level-form select[name='status']"
			).value = status;

			// Cập nhật action của form để gửi request đúng level
			document.querySelector(
				"#edit-level-form"
			).action = `/admin/level_configs/${levelId}`;
		});
	});
});

[#escape x as x?html]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.password.reset")}[#if showPowered][/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/${theme}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/${theme}/css/password.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $passwordForm = $("#passwordForm");
	var $password = $("#password");
	var $captcha = $("#captcha");
	var $captchaImage = $("#captchaImage");
	var $submit = $("input:submit");
	
	// 更换验证码
	$captchaImage.click(function() {
		$captchaImage.attr("src", "${base}/common/captcha.jhtml?captchaId=${captchaId}&timestamp=" + new Date().getTime());
	});
	
	// 表单验证
	$passwordForm.validate({
		rules: {
			newPassword: {
				required: true,
				minlength: ${setting.passwordMinLength}
			},
			rePassword: {
				required: true,
				equalTo: "#newPassword"
			},
			captcha: "required"
		},
		submitHandler: function(form) {
			$.ajax({
				url: $passwordForm.attr("action"),
				type: "POST",
				data: $passwordForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(message) {
					$.message(message);
					if (message.type == "success") {
						setTimeout(function() {
							$submit.prop("disabled", false);
							location.href = "${base}/";
						}, 3000);
					} else {
						$submit.prop("disabled", false);
						[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("resetPassword")]
							$captcha.val("");
							$captchaImage.attr("src", "${base}/common/captcha.jhtml?captchaId=${captchaId}&timestamp=" + new Date().getTime());
						[/#if]
					}
				}
			});
		}
	});

});
</script>
</head>
<body>
	[#include "/shop/${theme}/include/header.ftl" /]
	<div class="container password">
		<div class="row">
			<div class="span12">
				<div class="wrap">
					<div class="main">
						<div class="title">
							<strong>${message("shop.password.reset")}</strong>RESET PASSWORD
						</div>
						<form id="passwordForm" action="reset.jhtml" method="post">
							<input type="hidden" name="captchaId" value="${captchaId}" />
							<input type="hidden" name="username" value="${member.username}" />
							<input type="hidden" name="key" value="${key}" />
							<table>
								<tr>
									<th>
										${message("shop.password.username")}:
									</th>
									<td>
										${member.username}
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("shop.password.newPassword")}:
									</th>
									<td>
										<input type="password" id="newPassword" name="newPassword" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("shop.password.rePassword")}:
									</th>
									<td>
										<input type="password" name="rePassword" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
									</td>
								</tr>
								[#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("resetPassword")]
									<tr>
										<th>
											<span class="requiredField">*</span>${message("shop.captcha.name")}:
										</th>
										<td>
											<span class="fieldSet">
												<input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" /><img id="captchaImage" class="captchaImage" src="${base}/common/captcha.jhtml?captchaId=${captchaId}" title="${message("shop.captcha.imageTitle")}" />
											</span>
										</td>
									</tr>
								[/#if]
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<input type="submit" class="submit" value="${message("shop.password.submit")}" />
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/${theme}/include/footer.ftl" /]
</body>
</html>
[/#escape]
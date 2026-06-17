package aira.identity.login_risk

default allow_login = false
default require_step_up = false
default lock_account = false
default require_unlock_approval = true

allow_login {
  not input.account.locked
  input.risk.score < 70
}

require_step_up {
  not input.account.locked
  input.risk.score >= 70
  input.risk.score < 90
}

lock_account {
  input.failure.failed_attempts_in_window >= 5
}

lock_account {
  input.risk.score >= 90
}

deny_reason contains "ACCOUNT_LOCKED" {
  input.account.locked
}

deny_reason contains "TOO_MANY_FAILURES" {
  input.failure.failed_attempts_in_window >= 5
}

deny_reason contains "HIGH_RISK_LOGIN" {
  input.risk.score >= 90
}
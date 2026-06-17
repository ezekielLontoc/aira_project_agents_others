package aira.identity.login_risk

test_low_risk_allows_login {
  allow_login with input as {
    "account": {"locked": false},
    "risk": {"score": 20},
    "failure": {"failed_attempts_in_window": 0}
  }
}

test_medium_high_risk_requires_step_up {
  require_step_up with input as {
    "account": {"locked": false},
    "risk": {"score": 75},
    "failure": {"failed_attempts_in_window": 2}
  }
}

test_repeated_failures_lock_account {
  lock_account with input as {
    "account": {"locked": false},
    "risk": {"score": 55},
    "failure": {"failed_attempts_in_window": 5}
  }
}

test_critical_risk_locks_account {
  lock_account with input as {
    "account": {"locked": false},
    "risk": {"score": 95},
    "failure": {"failed_attempts_in_window": 1}
  }
}

test_locked_account_has_deny_reason {
  deny_reason["ACCOUNT_LOCKED"] with input as {
    "account": {"locked": true},
    "risk": {"score": 20},
    "failure": {"failed_attempts_in_window": 0}
  }
}
{ lib, ... }: {
  # Strengthen passwd(1) password policy with pam_pwquality
  security.pam.services.passwd.rules = {
    password = {
      pwquality = {
        order      = 0;
        control    = "requisite";
        modulePath = "pam_pwquality.so";
        args = [
          "retry=3"
          "minlen=12"
          "ucredit=-1"  # ≥1 uppercase
          "lcredit=-1"  # ≥1 lowercase
          "dcredit=-1"  # ≥1 digit
          "ocredit=-1"  # ≥1 symbol
        ];
      };
    };
  };

  # Keep your login.defs aging policy with an override
  environment.etc."login.defs".text = lib.mkForce ''
    PASS_MIN_DAYS 1
    PASS_MAX_DAYS 365
    PASS_WARN_AGE 7
    UMASK 077
  '';
}

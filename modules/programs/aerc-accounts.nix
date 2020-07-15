{ config, lib, ... }:

with lib;

{
  # Add patch to ignore accounts file permissions
  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
    aerc = super.aerc.override {
      patches = [
        ./runtime-sharedir.patch
        ./do-not-fail-on-open-permissions.patch
      ];
    };
  };

  options.aerc = {
    enable = mkEnableOption "Aerc";

    source = mkOption {
      type = types.enum [ "imap" "maildir" ];
      description = "Source for reading incoming emails.";
    };

    sendMailCommand = mkOption {
      type = types.nullOr types.str;
      default = if config.msmtp.enable then
        "msmtpq --read-envelope-from --read-recipients"
      else
        null;
      defaultText = literalExample ''
        if config.msmtp.enable then
          "msmtpq --read-envelope-from --read-recipients"
        else
          null
      '';
      example = "msmtpq --read-envelope-from --read-recipients";
      description = ''
        Command to send a mail. If not set, aerc will be in charge of sending mails.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = literalExample ''
        archive = Archive
        folders-sort = Archive,Sent
      '';
      description = "Extra lines to add to this account's specific configuration.";
    };
  };
}

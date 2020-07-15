self: super: {
  home-manager = super.callPackage ./home-manager { path = toString ./.; };

  # Add patch to ignore aerc accounts file permissions
  aerc = super.aerc.override {
    patches = [
      ./runtime-sharedir.patch
      ./do-not-fail-on-open-permissions.patch
    ];
  };
}

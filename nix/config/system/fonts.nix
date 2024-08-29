ctx:
let
  iosevka-name = "Iosevka Custom";
  iosevka = ctx.pkgs.iosevka.override {
    # <https://github.com/be5invis/Iosevka/blob/main/doc/language-specific-ligation-sets.md>
    privateBuildPlan = {
      exportGlyphNames = true;
      family = iosevka-name;
      # <https://github.com/be5invis/Iosevka?tab=readme-ov-file#ligations>
      ligations = {
        # enable all those not enabled by `dlig` below
        # (see the above link for a visual depiction):
        enables = [
          "eqexeq"
          "eqslasheq"
          "slasheq"
          "tildeeq"
        ];
        inherits = "dlig";
      };
      noCvSs = false;
      noLigation = false;
      spacing = "fontconfig-mono";
      variants.inherits = "ss08";
      webfontFormats = [ ]; # i.e. none
    };
    set = "custom";
  };
in
{
  packages = [ iosevka ] ++ (with ctx.pkgs; [ nerdfonts ]);
}

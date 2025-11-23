# Neovim 設定の別リポジトリ移行プラン

## 現状分析

### 現在の構成 (`programs/nvim`)

**ファイル構成:**
- `default.nix` - エントリーポイント。extraPackages定義とwrapperの呼び出し
- `wrapper.nix` - neovimバイナリをラップするシェルスクリプト生成
- `config.nix` - Lua設定ファイルをNix derivationとしてビルド
- `plugins/` - Nixプラグイン定義
  - `default.nix` - プラグインリストを属性セットに変換
  - `vim-plugins.nix` - vimPluginsFromVimのプラグインリスト
  - `lazy-nvim.nix` - カスタムlazy.nvim
- `lua/` - Lua設定ファイル
- `init.lua` - メインNeovim初期化ファイル

**統合方法:**
- `linux/home.nix`と`darwin/home.nix`から`../programs/nvim`をインポート
- `extraPackages`にLSP、フォーマッター、ツールを直接定義
- `home.packages`にneovimWrapperを追加
- シェルエイリアス(`vi`, `vim`)を設定

### asa1984.nvim の構成

**ファイル構成:**
```
asa1984.nvim/
├── flake.nix                      # メインエントリーポイント
├── nvim/                          # Neovim設定(Lua)
│   ├── init.lua
│   └── lua/plugins/
├── nix/                           # Nix定義
│   ├── lib/
│   │   └── make-neovim-wrapper.nix  # ラッパー関数
│   ├── pkgs/
│   │   ├── default.nix            # パッケージ定義エントリー
│   │   └── vim-plugins/           # プラグイン定義
│   ├── overlays/                  # カスタムオーバーレイ
│   ├── plugins.nix                # プラグインリスト
│   └── tools.nix                  # ツール定義(primary/secondary)
├── _sources/                      # 外部ソース定義
└── nvfetcher.toml                 # パッケージソース管理
```

**公開API:**
- `packages.${system}.neovim-minimal` - ツールなし
- `packages.${system}.neovim-light` - primaryツール込み
- `packages.${system}.neovim-full` - primary+secondaryツール込み
- `lib.${system}.makeNeovimWrapper` - カスタムツールセットでラップする関数

**統合パターン:**
```nix
inputs.asa1984-nvim.packages.${system}.neovim-full
# または
inputs.asa1984-nvim.lib.${system}.makeNeovimWrapper { tools = [...]; }
```

## 主要な違いと学び

### 1. アーキテクチャの違い

| 項目 | 現在の構成 | asa1984.nvim |
|------|----------|--------------|
| **配置** | モノリポ内に埋め込み | 独立したflake |
| **公開API** | なし(内部利用のみ) | packages, lib.makeNeovimWrapper |
| **ツール管理** | default.nixに直接列挙 | tools.nixで階層化(primary/secondary) |
| **パッケージバリエーション** | 1種類 | 3種類(minimal/light/full) |
| **オーバーレイ** | なし | nix/overlaysで拡張可能 |

### 2. ベストプラクティス

**asa1984.nvimから学ぶべき点:**

1. **階層化されたツール管理**
   - `tools.nix`でprimary/secondaryに分類
   - 用途別パッケージ(minimal/light/full)提供
   - 柔軟性とパフォーマンスのバランス

2. **明確な公開API**
   - `lib.makeNeovimWrapper`関数でカスタマイズ可能
   - `packages`で事前設定済みバリアントを提供
   - 消費側で選択肢を持てる

3. **分離されたNix定義**
   - `nix/`ディレクトリで構造化
   - `lib/`, `pkgs/`, `overlays/`で関心の分離
   - 再利用性と保守性向上

4. **nvfetcherの活用**
   - 外部プラグインソースを`nvfetcher.toml`で管理
   - 自動更新とロック可能

5. **flake-partsの活用**
   - perSystemでマルチアーキテクチャ対応
   - モジュール化された構成

## 移行プラン

### フェーズ1: 新規リポジトリのセットアップ

**リポジトリ名:** `nvim`

**ディレクトリ構造:**
```
nvim/
├── flake.nix
├── flake.lock
├── .gitignore
├── README.md
├── CLAUDE.md              # Claude Code用のガイダンス
├── nvim/                  # 現在のlua/からコピー
│   ├── init.lua
│   └── lua/
│       ├── config/
│       └── plugins/
└── nix/
    ├── lib/
    │   └── make-neovim-wrapper.nix
    ├── pkgs/
    │   ├── default.nix
    │   └── vim-plugins/
    │       └── default.nix
    ├── plugins.nix
    └── tools.nix
```

**必要な作業:**

1. **リポジトリ初期化**
   ```bash
   mkdir ~/projects/nvim
   cd ~/projects/nvim
   git init
   ```

2. **flake.nixの作成**
   - `inputs`: nixpkgs, flake-parts, treefmt-nix
   - `outputs`: packages.default (すべてのツールを含む), lib.makeNeovimWrapper
   - `treefmt`: flake.nix内でstyluaを有効化

3. **Lua設定のコピーと調整**
   ```bash
   cp -r ~/.config/nix-config/programs/nvim/lua nvim/
   cp ~/.config/nix-config/programs/nvim/init.lua nvim/
   ```
   - init.luaのプレースホルダー参照を調整

4. **Nix定義の再構築**
   - `nix/lib/make-neovim-wrapper.nix`: ラッパー関数の実装
   - `nix/tools.nix`: 現在のextraPackagesをそのまま移行
     - telescope用ツール (ripgrep, fd)
     - LSPサーバー (全言語)
     - フォーマッター (全言語)
   - `nix/plugins.nix`: 現在のvim-plugins.nixから移行
   - `nix/pkgs/default.nix`: プラグインパッケージング

### フェーズ2: nix-configリポジトリの更新

**変更箇所:**

1. **flake.nixへのinput追加**
   ```nix
   inputs = {
     # 既存のinputs...
     nvim = {
       url = "github:gawakawa/nvim";  # または "path:/home/iota/projects/nvim" (開発時)
       inputs.nixpkgs.follows = "nixpkgs";
     };
   };
   ```

2. **home.nixの更新**

   **linux/home.nix & darwin/home.nix:**
   ```nix
   { config, lib, pkgs, nvim, system, ... }:
   {
     home = {
       # ...
       packages = with pkgs; [
         curl
         # Neovimを追加
         nvim.packages.${system}.default
       ];
     };

     # シェルエイリアスを追加
     home.shellAliases = {
       vi = "nvim";
       vim = "nvim";
     };

     imports = [
       ../programs/zsh.nix
       ../programs/direnv.nix
       ../programs/git.nix
       ../programs/wezterm
       # ../programs/nvim を削除
       ../programs/starship.nix
       # linux/home.nixの場合のみ以下も含む
       # ../programs/hyprland.nix
       # ../programs/waybar.nix
     ];
   }
   ```

3. **specialArgsの更新**

   **flake.nix:**
   ```nix
   # nixosConfigurations
   home-manager = {
     # ...
     extraSpecialArgs = {
       inherit (inputs) self nixpkgs nvim;
       system = "x86_64-linux";
     };
   };

   # darwinConfigurations
   home-manager = {
     # ...
     extraSpecialArgs = {
       inherit (inputs) self nixpkgs nvim;
       system = "aarch64-darwin";
     };
   };
   ```

4. **programs/nvimディレクトリの削除**
   ```bash
   git rm -r programs/nvim
   ```

### フェーズ3: カスタマイズオプション(オプション)

**高度な使用例:**

```nix
# カスタムツールセットでNeovimを構築
{ nvim, pkgs, system, ... }:
{
  home.packages = [
    (nvim.lib.${system}.makeNeovimWrapper {
      tools = with pkgs; [
        # カスタムツールのみ
        ripgrep
        fd
        lua-language-server
        nixfmt
      ];
    })
  ];
}
```

### フェーズ4: 検証とクリーンアップ

**検証手順:**

1. **新規リポジトリのビルドテスト**
   ```bash
   cd ~/projects/nvim
   nix flake check
   nix build .#neovim-minimal
   nix build .#neovim-light
   nix build .#neovim-full
   ```

2. **nix-configでのビルドテスト**
   ```bash
   cd ~/.config/nix-config
   nix flake lock --update-input nvim
   # NixOSの場合
   nix build .#nixosConfigurations.nixos.config.system.build.toplevel
   # Darwinの場合
   nix build .#darwinConfigurations.mac.system
   ```

3. **動作確認**
   ```bash
   # home-manager switch後
   nvim --version
   nvim  # プラグイン読み込み確認
   ```

4. **クリーンアップ**
   - `programs/nvim`ディレクトリ削除のコミット
   - 不要なcommon-packages.nixからneovim関連を削除(該当する場合)

## 移行のメリット

1. **独立性**: Neovim設定の変更がnix-configリポジトリに影響しない
2. **再利用性**: 他のマシンやプロジェクトで簡単に利用可能
3. **バージョン管理**: flake.lockで特定バージョンを固定可能
4. **柔軟性**: minimal/light/fullやカスタムツールセットを選択可能
5. **保守性**: 関心の分離により各リポジトリがシンプルに
6. **共有可能**: GitHubで公開すれば他ユーザーも利用可能

## 移行のリスクと対策

| リスク | 対策 |
|--------|------|
| 設定が動かない | フェーズ1で十分にテストしてからフェーズ2へ |
| プラグインの依存関係 | nvfetcher導入でバージョン固定 |
| パフォーマンス低下 | lazy.nvim設定を維持、不要ツールは除外 |
| 複数リポジトリ管理の複雑化 | CLAUDE.mdとREADMEで明確にドキュメント化 |

## 推奨実装順序

1. **新規リポジトリ作成** (~/projects/nvim)
2. **Lua設定のコピー** (動作確認済みの状態を保持)
3. **Nix定義の実装** (make-neovim-wrapper, tools, plugins)
4. **flake.nixの完成** (packages, lib公開)
5. **ローカルビルドテスト** (nix build)
6. **GitHub公開** (オプションだが推奨)
7. **nix-config更新** (input追加、home.nix変更)
8. **統合テスト** (home-manager switch)
9. **programs/nvim削除** (git rm)
10. **ドキュメント更新** (CLAUDE.md, README.md)

## 次のステップ

実装を進める場合、以下の順序で作業を行います:

1. 新規リポジトリのセットアップとファイル構造作成
2. asa1984.nvimを参考にしたNix定義の実装
3. Lua設定の移行と調整
4. nix-configリポジトリの更新

## 参考リソース

- asa1984.nvim: https://github.com/asa1984/asa1984.nvim
- flake-parts: https://flake.parts/
- nvfetcher: https://github.com/berberman/nvfetcher

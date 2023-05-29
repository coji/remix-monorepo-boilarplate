NPM_EXISTS := $(shell command -v npm 2> /dev/null)
PNPM_EXISTS := $(shell command -v pnpm 2> /dev/null)

# 初期の開発環境(ローカル)設定
setup: env
ifeq ($(NPM_EXISTS),) # npm が存在し、かつ、pnpmが存在しない場合はpnpm をインストール
	@echo "npm コマンドが存在しません。"
else ifeq ($(PNPM_EXISTS),)
	npm i -g pnpm
endif
ifeq ($(PNPM_EXISTS),) # pnpm が存在する場合は admin, crawler の node パッケージをインストール (vscode用)
	@echo "pnpm コマンドが存在しません。"
else
	docker compose up -d db
	pnpm i --frozen-lockfile
	pnpm run -r setup
endif


# envファイルを設定
env:
	if [ ! -f .env ]; then cp .env.example .env; fi
	if [ ! -f apps/admin/.env ]; then ln -s ../../.env apps/admin/.env; fi
	if [ ! -f apps/web/.env ]; then ln -s ../../.env apps/web/.env; fi
	if [ ! -f packages/database/.env ]; then ln -s ../../.env packages/database/.env; fi


# すべてのコンテナ、イメージ、ボリュームを削除
clean:
	docker compose down --rmi all --volumes --remove-orphans
	rm -Rf postgres-data data
	pnpm run -r clean


# 再セットアップ
reset: clean setup


# ローカル開発サーバを起動
dev:
	docker compose up -d db
	pnpm turbo dev


# DB停止
down:
	docker compose down


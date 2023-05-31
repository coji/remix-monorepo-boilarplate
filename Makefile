
# 初期の開発環境(ローカル)設定
setup: env
	corepack enable
	corepack prepare pnpm@8.5.1 --activate
	docker compose up -d --wait
	pnpm i --frozen-lockfile
	pnpm run -r setup


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
	docker compose up -d db --wait
	pnpm turbo dev


# DB停止
down:
	docker compose down


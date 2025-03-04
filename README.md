# README

## Required

```
- ruby version 3.1.2
- rails 7.0.7
- mysql 8
```

## Run local

```
1. bundle install
2. cp .env.dev .env # config user, pass
3. rake db:create && rake db:migrate
4. rake db:seed # tạo data sample
5. rails s # localhost:3000
```

## Workflow git

```
- Checkout từ nhánh develop ra làm
- Tên nhánh nếu làm feature mới: feat/1234 (1234: là mã issue trên co)
- Fix bug: fix/1234 (1234: là mã issue trên co)
=> Khi tạo pullrequest (PR) thì tạo Pull merge vào develop
```
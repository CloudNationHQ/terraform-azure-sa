# Changelog

## [0.8.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.7.0...v0.8.0) (2024-02-28)


### Features

* improved alignment for several properties and added some missing ones ([#32](https://github.com/CloudNationHQ/terraform-azure-sa/issues/32)) ([fb7a1a9](https://github.com/CloudNationHQ/terraform-azure-sa/commit/fb7a1a96063428bf79c26b45c1bed1da24650a2f))

## [0.7.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.6.0...v0.7.0) (2024-02-05)


### Features

* change default value cross tenant replication to false ([#23](https://github.com/CloudNationHQ/terraform-azure-sa/issues/23)) ([1dadbfd](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1dadbfdcbf91794e5dfa8a7751ef741abc5ac16a))
* change defaults bypass property network rules ([#30](https://github.com/CloudNationHQ/terraform-azure-sa/issues/30)) ([f4147ba](https://github.com/CloudNationHQ/terraform-azure-sa/commit/f4147bace32f39dbffe546a230926f5cced72ea8))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/azidentity ([#26](https://github.com/CloudNationHQ/terraform-azure-sa/issues/26)) ([9be36c1](https://github.com/CloudNationHQ/terraform-azure-sa/commit/9be36c1bdedc9c3a2121a251bfdb5ee20957be81))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#27](https://github.com/CloudNationHQ/terraform-azure-sa/issues/27)) ([b739c64](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b739c6422b99d9846b94dff38c16df1586962f5e))
* small refactor workflows ([#25](https://github.com/CloudNationHQ/terraform-azure-sa/issues/25)) ([7d27e7f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7d27e7fff07d8a1909118dcdf577a982bec4d8e9))


### Bug Fixes

* make blob properties fully optional again ([#31](https://github.com/CloudNationHQ/terraform-azure-sa/issues/31)) ([340a882](https://github.com/CloudNationHQ/terraform-azure-sa/commit/340a882337406a99e97d471d7a1b0201a088d871))

## [0.6.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.5.0...v0.6.0) (2024-01-16)


### Features

* add several missing properties ([#19](https://github.com/CloudNationHQ/terraform-azure-sa/issues/19)) ([b0b9597](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b0b95972c58ad15c00c6bbc74ad1500dc2b8f0fa))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#18](https://github.com/CloudNationHQ/terraform-azure-sa/issues/18)) ([758d745](https://github.com/CloudNationHQ/terraform-azure-sa/commit/758d745d3e9ccffb35b122484fa16471e7024e38))
* retention and restore policies are fully optional now ([#20](https://github.com/CloudNationHQ/terraform-azure-sa/issues/20)) ([1e94788](https://github.com/CloudNationHQ/terraform-azure-sa/commit/1e947883d294b875ed9d26f43c3abc55989542d5))

## [0.5.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.4.0...v0.5.0) (2024-01-12)


### Features

* Improved name property flexibility with manual and default options ([#16](https://github.com/CloudNationHQ/terraform-azure-sa/issues/16)) ([c101a0f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/c101a0fc712df97fcd03584e9a32eef8a2e4c5c4))

## [0.4.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.3.0...v0.4.0) (2023-12-19)


### Features

* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/storage/armstorage ([#10](https://github.com/CloudNationHQ/terraform-azure-sa/issues/10)) ([b393565](https://github.com/CloudNationHQ/terraform-azure-sa/commit/b3935652c8ec5cb203f7c8c78e521e44d0ba54fe))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#11](https://github.com/CloudNationHQ/terraform-azure-sa/issues/11)) ([cf34c3b](https://github.com/CloudNationHQ/terraform-azure-sa/commit/cf34c3b768257863fb0eea75746456d115e0454a))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#7](https://github.com/CloudNationHQ/terraform-azure-sa/issues/7)) ([101829f](https://github.com/CloudNationHQ/terraform-azure-sa/commit/101829fc4a8a347d91f54b7a4425f57a25084dde))
* **deps:** bump golang.org/x/crypto from 0.14.0 to 0.17.0 in /tests ([#12](https://github.com/CloudNationHQ/terraform-azure-sa/issues/12)) ([7b07c5a](https://github.com/CloudNationHQ/terraform-azure-sa/commit/7b07c5aaf08d2dbf7442f6d8f6556ebc9d611d4f))

## [0.3.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.2.0...v0.3.0) (2023-11-07)


### Features

* add support for network rules ([#5](https://github.com/CloudNationHQ/terraform-azure-sa/issues/5)) ([9b63cde](https://github.com/CloudNationHQ/terraform-azure-sa/commit/9b63cde7723d26082525eb1027735582b95f9701))

## [0.2.0](https://github.com/CloudNationHQ/terraform-azure-sa/compare/v0.1.0...v0.2.0) (2023-11-03)


### Features

* fix module source references in examples ([#3](https://github.com/CloudNationHQ/terraform-azure-sa/issues/3)) ([fabd090](https://github.com/CloudNationHQ/terraform-azure-sa/commit/fabd0902a537d0d40d04cabb0c5f65769cb04046))

## 0.1.0 (2023-11-02)


### Features

* add initial resources ([#1](https://github.com/CloudNationHQ/terraform-azure-sa/issues/1)) ([d983841](https://github.com/CloudNationHQ/terraform-azure-sa/commit/d98384188d09f4710092b6f23e977f8d3f3c1f49))

---
description: Analyze ESLint errors in TypeScript/JavaScript files and fix them automatically
allowed-tools: Bash(npx eslint:*), Read, Write, Glob
---

# コンテキスト

- 現在のエラー状況: !`npx eslint "$(git ls-files -- '*.ts' '*.tsx' '*.js' '*.jsx')"`

# あなたのタスク

エラー報告をされてるファイルを修正し、エラーをなくしましょう。次の順で、エラーを修正します:

1. エラーが起きてるファイルに対して、`npx eslint --fix <エラーが起きているファイル名>` を実行し、自動で修正できる部分を修正します
2. 以下の参考文献や修正例に従って、修正できる部分を修正します。
3. 修正の仕方が分からない部分はそのまま残し、最終的に修正できなかった部分を報告します。

## 参考文献

- [ESLint公式のルールリファレンス](https://eslint.org/docs/latest/rules/)
  - この中から該当するルールの詳細ページを見ると、修正方法が載っている
- [typescript-eslint公式のルールリファレンス](https://typescript-eslint.io/rules/)
  - `@typescript-eslint/` から始まるルールの解説ページ
  - この中から該当するルールの詳細ページを見ると、修正方法が載っている

## よくあるESLintエラーと修正方法

### `@typescript-eslint/no-unnecessary-condition`

不必要な条件チェックがある場合にこのエラーが出ます。どこの条件チェックが不必要か分析し、その部分のみ取り除く必要があります。

よくある事例:

- nullable な値じゃないのに `x === undefined` のように nullable かどうか判定している
  - 修正方法: `x === undefined` の条件を消す
- 配列の長さチェック後に配列が存在するかチェックしている
  - 例: `if (arr.length > 0 && arr) { ... }`
  - 修正方法: `arr.length > 0` のチェックで十分なので、`&& arr` を削除
- 必ず true になる条件をチェックしている
  - 例: `if (true) { ... }` や `const isEnabled = true; if (isEnabled) { ... }`
  - 修正方法: 条件分岐を削除して中身を直接実行
- TypeScript の型定義で non-nullable な値に対して null チェックをしている
  - 例: `function foo(x: string) { if (x !== null) { ... } }`
  - 修正方法: 型定義が `string` なら null にはならないので条件を削除

間違った修正例:

- `x === undefined && x === ''` のような条件で、`x === undefined` の部分のみが不要なのにも関わらず、全て条件チェックを消してしまう
  - `x === ''` は残す必要がある。全て消すのではなく、必要な部分を見定め、不要な部分のみ消す必要がある

### `@typescript-eslint/no-unsafe-type-assertion`

型アサーションが安全でない場合にこのエラーが出ます。

よくある事例:

- `any` 型の値を具体的な型にアサーションしている
  - 修正方法: 型ガードを使用するか、適切な型注釈を追加する
- `unknown` 型を直接別の型にアサーションしている
  - 修正方法: 型ガードで検証してから使用する

修正例:

```typescript
// Before
const value = data as string;

// After
const value = typeof data === "string" ? data : "";
```

### `@typescript-eslint/no-explicit-any`

`any` 型を明示的に使用している場合にこのエラーが出ます。

修正方法:

- 具体的な型を定義する
- `unknown` 型を使用して型ガードで絞り込む

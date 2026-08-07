#import "../styles.typ": *

= 参考資料

#chapter-lead[
  実行環境の性能と対応機能は、更新によって変わる。
  実装するときは、採用するモデルやアセットの版を記録し、配布元の資料と仕様書を改めて確認してほしい。
  本書の実測値と不具合の記述は、こかげの開発で作られた設計資料と検証記録に基づく。
]

// 参考資料の一覧は、慣例どおり本文より一段小さく組む。
#set text(size: 8.6pt)

- #source-link([Qwen3.5-4B モデルカード], "https://huggingface.co/Qwen/Qwen3.5-4B"):カタログ既定の言語モデル本体。2B・9B も同じ配布元の系列で公開されている。
- #source-link([llama.cpp 公式リポジトリ], "https://github.com/ggml-org/llama.cpp"):モデルファイル形式、量子化、CPU と GPU による推論。
- #source-link([fllamer], "https://github.com/ProjectKokage/fllamer"):llama.cpp を同梱する、こかげの Flutter 向け推論ラッパー。アプリ本体と別に公開している。
- #source-link([Gemma 公式ページ], "https://deepmind.google/models/gemma"):第1章と第2章で比較対象にした、オープンモデルの系列。
- #source-link([Unsloth 公式ドキュメント], "https://unsloth.ai/docs"):言語モデルのファインチューニング(LoRA)と、llama.cpp 用 GGUF への書き出し。言語モデル型の音声合成の学習も扱う。
- #source-link([sherpa-onnx 公式資料], "https://k2-fsa.github.io/sherpa/onnx/"):端末内の音声区間検出、音声認識、話者分離。
- #source-link([Silero VAD], "https://github.com/snakers4/silero-vad"):音声区間検出モデル。
- #source-link([SenseVoice], "https://github.com/FunAudioLLM/SenseVoice"):多言語音声認識モデル。発話単位の感情・音響イベントのラベルを返す。
- #source-link([pyopenjtalk], "https://github.com/r9y9/pyopenjtalk"):Open JTalk 系の、日本語の読みの解析(G2P)。こかげの解析器の実装元。
- #source-link([Open JTalk 辞書 1.11 の配布リリース], "https://github.com/r9y9/open_jtalk/releases/tag/v1.11.1"):こかげがハッシュを固定して取得する、読みの解析用の辞書(展開後 107 MB)。
- #source-link([Kokoro 82M タイムスタンプ対応 ONNX], "https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX-timestamped/tree/dd4401a9add81ac692d20e240d22ec9dda82cc29"):こかげが版を固定した、波形とトークン時刻を返す音声合成モデル。
- #source-link([Irodori-TTS 公式リポジトリ], "https://github.com/Aratako/Irodori-TTS"):日本語の反復生成型音声合成。学習(全体・LoRA・話者埋め込み)と推論の公式実装。
- #source-link([Irodori-TTS-v4-Small], "https://huggingface.co/Aratako/Irodori-TTS-v4-Small"):第2章で検討した候補の重みとモデルカード。評価の数値と既知の制限が記載されている。
- #source-link([Qwen3-TTS 公式リポジトリ], "https://github.com/QwenLM/Qwen3-TTS"):0.6B と 1.7B の多言語音声合成の系列。逐次生成、3 秒からの声の複製、指示による声の設計。Apache-2.0。
- #source-link([k2-fsa/OmniVoice 公式リポジトリ], "https://github.com/k2-fsa/OmniVoice"):600 を超える言語の音声合成。話者属性の指定と非言語音の記法。Apache-2.0。
- #source-link([LFM2.5-Audio-1.5B-JP], "https://huggingface.co/LiquidAI/LFM2.5-Audio-1.5B-JP"):第2章で比較した日本語対応の音声ネイティブモデル。LFM Open License v1.0。
- #source-link([LFM2.5-1.2B-JP], "https://huggingface.co/LiquidAI/LFM2.5-1.2B-JP"):第2章の小節で言語別の頭として挙げた、日本語最適化のテキストモデル。
- #source-link([LFM2.5-1.2B-Instruct], "https://huggingface.co/LiquidAI/LFM2.5-1.2B-Instruct"):同じ系列の汎用基本版。GGUF を配布し、4 ビット級量子化の重みは 1 GB を切る。
- #source-link([Qwen3-Omni], "https://github.com/QwenLM/Qwen3-Omni"):音声・画像の理解と発話の逐次生成を一体で持つ大型のオープンモデル。
- #source-link([granite-embedding-97m-multilingual-r2], "https://huggingface.co/ibm-granite/granite-embedding-97m-multilingual-r2"):検索と記憶が共有する多言語埋め込みモデル。
- #source-link([VRM 1.0 仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/README.md"):人型の骨格、表情、視線制御、揺れもの。
- #source-link([VRM 表情仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/expressions.md"):作者による口・瞬き・視線の上書き規則。
- #source-link([VRM 動作 1.0 仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm_animation-1.0/README.md"):VRMA の人型骨格、表情、視線制御。
- #source-link([Flutter Scene], "https://pub.dev/packages/flutter_scene"):採用した Flutter 向けの 3D描画エンジン。こかげは版を固定し、表情の頂点合成を自前で補っている。
- #source-link([AliciaSolid(UniVRM 同梱のテスト用 VRM)], "https://github.com/vrm-c/UniVRM/blob/master/Tests/Models/Alicia_vrm-0.51/AliciaSolid_vrm-0.51.vrm"):開発と検証に使ったキャラクター。こかげは初期設定の既定候補としてこの配布ページを示すだけで同梱はせず、利用条件の確認は利用者に委ねる。
- #source-link([ChatVRM], "https://github.com/pixiv/ChatVRM"):基礎の待機モーションとして採用したクリップ(MIT)の出典。
- #source-link([AITuber OnAir], "https://github.com/shinshin86/aituber-onair"):設計の選択的な参照元。演出の着想は借り、時計と所有権の設計は借りない。
- #source-link([Doughty (2001)], "https://doi.org/10.1097/00006324-200110000-00011"):瞬きの頻度が人と作業で大きく変わることの観察研究。3.2 の間隔の仮説の参照元。
- #source-link([VanderWerf ほか (2003)], "https://doi.org/10.1152/jn.00557.2002"):自発的な瞬きは閉じより開きが遅い、という計測。3.2 の瞬きの形の参照元。
- #source-link([Lee・Badler・Badler (2002)], "https://doi.org/10.1145/566570.566629"):話す・聞くの状態で目の動きを変える統計モデル。3.2 の視線のゆらぎの参照元。
- #source-link([Andrist ほか (2013)], "https://pages.cs.wisc.edu/~bilge/pubs/2013/IVA13-Andrist.pdf"):会話エージェントの視線そらしの研究。考えている間に視線を外す設計の参照元。
- #source-link([HY-Motion-1.0 公式リポジトリ], "https://github.com/Tencent-Hunyuan/HY-Motion-1.0"):テキストから人型モーションを生成するモデル。モーション素材の生成に開発機で使用し、端末には載せない。
- #source-link([NVIDIA ARDY 公式ページ], "https://research.nvidia.com/labs/sil/projects/ardy/"):テキストと運動学的制約からの逐次モーション生成(SIGGRAPH 2026)。コードは Apache-2.0、重みは NVIDIA Open Model License。

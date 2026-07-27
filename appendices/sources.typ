#import "../styles.typ": *

= 参考資料

#chapter-lead[
  実行環境の性能と対応機能は、更新によって変わる。
  実装するときは、採用するモデルや音声資産の版を記録し、利用する実行環境と仕様書を改めて確認する。
]

== 一次資料

- #source-link([llama.cpp 公式コード保管庫], "https://github.com/ggml-org/llama.cpp")：モデルファイル形式、量子化、中央処理装置と画像処理装置による推論。
- #source-link([llama.cpp 性能調整資料], "https://github.com/ggml-org/llama.cpp/blob/master/docs/development/token_generation_performance_tips.md")：画像処理装置への処理移行と中央処理装置の並列処理数。
- #source-link([llama.cpp 投機的生成の例], "https://github.com/ggml-org/llama.cpp/tree/master/examples/speculative")：下書きモデルを使う公式例。
- #source-link([sherpa-onnx 公式資料], "https://k2-fsa.github.io/sherpa/onnx/")：端末内の音声認識と音声活動検出。
- #source-link([Qwen3-TTS 公式コード保管庫], "https://github.com/QwenLM/Qwen3-TTS")：0.6B と 1.7B の各モデル、日本語、逐次生成、声の設計、話し方の指示、声質複製。
- #source-link([k2-fsa/OmniVoice 公式コード保管庫], "https://github.com/k2-fsa/OmniVoice")：0.6B の言語モデルと音声トークナイザを使う拡散型音声合成、対応言語、声質複製、声の属性指定、生成 API、コードと学習済みモデルで異なる利用条件。
- #source-link([Kokoro 82M タイムスタンプ対応 ONNX], "https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX-timestamped/tree/dd4401a9add81ac692d20e240d22ec9dda82cc29")：Kokage が固定した波形と内部トークン予測時間を返す候補。
- #source-link([Montreal Forced Aligner 公式資料], "https://montreal-forced-aligner.readthedocs.io/en/v3.4.1/user_guide/index.html")：既知の発話文と音声から時刻付きの単語と音素を求める処理。
- #source-link([VRM 1.0 仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/README.md")：人型の骨格、表情、視線制御、髪や衣服の揺れ。
- #source-link([VRM 表情仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/expressions.md")：表情の上書き規則。
- #source-link([VRM 動作 1.0 仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm_animation-1.0/README.md")：VRMA で使う人型の骨格、表情、視線制御。

== Kokage の設計資料

- `../kokage/docs/architecture/runtime_boundaries.md`
- `../kokage/docs/architecture/trust_boundaries.md`
- `../kokage/docs/fllamer_integration_report.md`
- `../kokage/docs/audio_pipeline_report.md`
- `../kokage/docs/kokoro_japanese_tts_report.md`
- `../kokage/docs/character_performance_pipeline_design.md`
- `../kokage/docs/vrm_emotion_motion_animation_report.md`

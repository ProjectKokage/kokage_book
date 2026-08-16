#import "../styles.typ": *

= 参考資料

#chapter-lead[
  モデルやライブラリが対応する機能と利用条件は更新される。
  実装時には、採用するモデル、アセット、推論ランタイムの版を記録し、配布元の一次資料を読み直す必要がある。
]

// 参考資料の一覧は、慣例どおり本文より一段小さく組む。
#set text(size: 8.6pt)

- #source-link([Qwen3.5-2B], "https://huggingface.co/Qwen/Qwen3.5-2B")、#source-link([Qwen3.5-4B], "https://huggingface.co/Qwen/Qwen3.5-4B")、#source-link([Qwen3.5-9B], "https://huggingface.co/Qwen/Qwen3.5-9B")：第 1 章で検討候補として挙げた公式ベースモデル。
  各配布ページにApache-2.0の記載がある。
- #source-link([llama.cpp公式リポジトリ], "https://github.com/ggml-org/llama.cpp")：GGUF、量子化、チャットテンプレート、CPUとGPUによる推論。
- #source-link([fllamer], "https://github.com/ProjectKokage/fllamer")：こかげが使うFlutter向け推論ラッパー。
  llama.cppを同梱する。
- #source-link([sherpa-onnx公式資料], "https://k2-fsa.github.io/sherpa/onnx/")：端末内の音声区間検出と音声認識。
- #source-link([Silero VAD], "https://github.com/snakers4/silero-vad")：音声区間検出モデル。
- #source-link([SenseVoice], "https://github.com/FunAudioLLM/SenseVoice")：こかげが使う多言語音声認識モデル。
- #source-link([pyopenjtalk], "https://github.com/r9y9/pyopenjtalk")：Open JTalkを使う日本語の読みとアクセントの解析。
- #source-link([misakid], "https://github.com/ProjectKokage/misakid")：Kokoroへ渡す読みの解析を担うDartライブラリ。
- #source-link([Kokoro-82Mモデルカード], "https://huggingface.co/hexgrad/Kokoro-82M")：基盤モデルの仕様とApache-2.0の記載。
- #source-link([Kokoro-82Mの時刻対応ONNX], "https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX-timestamped/tree/dd4401a9add81ac692d20e240d22ec9dda82cc29")：こかげが版を固定して使うONNX版で、波形とトークン時刻を返す。
  再配布条件は基盤モデルと分けて審査する。
- #source-link([fonix], "https://github.com/ProjectKokage/fonix")：音声モデルをDartとFlutterから使う自前のラッパー。
- #source-link([VRM 1.0仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/README.md")：人型骨格、表情、視線、揺れものの仕様。
- #source-link([VRM表情仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm-1.0/expressions.md")：作者が指定する口、瞬き、視線の上書き規則。
- #source-link([VRM Animation 1.0仕様], "https://github.com/vrm-c/vrm-specification/blob/master/specification/VRMC_vrm_animation-1.0/README.md")：VRMAの人型骨格と動作の仕様。
- #source-link([Flutter Scene], "https://pub.dev/packages/flutter_scene")：こかげが採用するFlutter向け3D描画エンジン。
- #source-link([flvtterm], "https://github.com/ProjectKokage/flvtterm")：VRMとVRMAを読み込み、描画エンジンへつなぐ自前のライブラリ。
- #source-link([AliciaSolid], "https://github.com/vrm-c/UniVRM/blob/master/Tests/Models/Alicia_vrm-0.51/AliciaSolid_vrm-0.51.vrm")：本文の機能調査で例にした検証用VRM。
- #source-link([HY-Motion-1.0], "https://github.com/Tencent-Hunyuan/HY-Motion-1.0")、#source-link([公式ライセンス], "https://huggingface.co/tencent/HY-Motion-1.0/blob/main/LICENSE.txt")：動作生成モデルの仕様と、生成物の利用にも適用される地域条件。

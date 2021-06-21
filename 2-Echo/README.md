# 回声隐藏：

- 这是测试！！！！！！！！！！！！！原理：人类听觉系统具有屏蔽特性，即，相距很短的几十ms 语音内），幅度较弱者会被较强者遮蔽。通过利用此特性，在音频中引入回声来嵌入秘密信息。将音频载体s(n)分段，每段长度从几毫秒到几十毫秒，每段用于嵌入1 bit的密信,然后构造2个分别代表密信“0”和“1”的不同回声核。回声核是回声隐藏算法最重要的部分。回声核的回声幅度α一般值取为 0. 6，0. 9，用 2 个不同的延迟时长 d0，d1代表不同密信比特，一般延迟时长为0. 5~2 ms。当密信比特为0时，该段加上代表“0”的回声核；密信比特为 1 时，该段加上代表“1”的回声核。回声核的回声幅度需要精心挑选：当回声幅度过小时，会出现提取失败的问题；但当回声幅度过大时，又会使隐藏的效果大大降低。传统回声核可表示为：		
  							h(n)=δ(n)+α δ(n-d)
  式中：h(n)示回声核，δ(n)表示单位脉冲信号，α 为回声幅度，d为回声延迟。
  
- CoverDir : 存放cover的载体WAVE文件。
- StegoDir : 存放stego的载体WAVE文件。
- MsgDir : 存放消息的文本文件。

  
# Echo Hiding：

Principe: Human auditory system has shielding characteristics, that is, within a short distance of tens of ms of speech), the weaker ones will be shielded by the stronger ones. By taking advantage of this feature, an echo is introduced into the audio to embed secret information. The audio carrier s(n) is segmented, each segment is from a few milliseconds to tens of milliseconds, and each segment is used to embed a 1-bit secret message，then construct two different echo nuclei representing the secret letter "0" and "1" respectively。The echo nucleus is the most important part of the echo hiding algorithm. The echo amplitude $\alpha$ of the echo core is generally taken as 0.6~0.9, with two different delay durations d_{0}, d_{1}represents different secret message bits, and the general delay duration is 0.5~2 ms. When the secret message bit is 0, the echo core representing "0" is added to the segment; when the secret message bit is 1, the echo core representing "1" is added to the segment. The echo amplitude of the echo nucleus needs to be carefully selected: when the echo amplitude is too small, extraction failure will occur; but when the echo amplitude is too large, the hidden effect will be greatly reduced. The traditional echo core can be expressed as:											h(n)=δ(n)+α δ(n-d)
whereas h(n) represents the echo nucleus, δ(n) represents the unit pulse signal, α is the echo amplitude, and dis the echo delay.

- CoverDir : Store the cover carrier WAVE file.
- StegoDir : Store the carrier WAVE file of stego.
- MsgDir : Text file for storing messages.

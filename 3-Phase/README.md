# 相位隐写：

- 基本原理：利用人耳听力系统对声音绝对相位不敏感的特性，用代表秘密信息的参考相位代替语音信号的绝对相位。为保证信号间的相对相位不变，所有随后信号的绝对相位也同时改变。在接收端，根据同步机制进行相位检测。

- StegoDir : 存放stego的载体WAVE文件。

- MsgDir : 存放消息的文本文件。

  
# Phase Hiding：

- Principe： Taking advantage of the insensitivity of the human ear hearing system to the absolute phase of the sound, the absolute phase of the speech signal is replaced with a reference phase representing secret information. To ensure that the relative phase between the signals remains unchanged, the absolute phases of all subsequent signals also change at the same time. At the receiving end, phase detection is performed according to the synchronization mechanism.
- CoverDir : Store the cover carrier WAVE file.
- StegoDir : Store the carrier WAVE file of stego.

- MsgDir : Text file for storing messages.

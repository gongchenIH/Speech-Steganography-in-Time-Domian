# LSBR：
- 原理：根据二进制消息替换载体的LSB位。消息会嵌入WAVE文件的data部分，即44字节后，参考[WAVE文件格式图](https://github.com/gongchenIH/Pic/blob/master/WaveFormat.png)，方便理解。

- CoverDir : 存放cover的载体WAVE文件。

- StegoDir : 存放stego的载体WAVE文件。

- MsgDir : 存放消息的文本文件。

                                                      ![Image](https://github.com/gongchenIH/Pic/blob/master/WaveFormat.png)
  
  
 
# LSBR：

- Principle:Least Significant Bit Replacement (LSBR)is to replace the LSB  bit of the carrier according to the binary message.The message will be embedded in the data part of the WAVE file, which is after 44 bytes.
- CoverDir : Store the cover carrier WAVE file.
- StegoDir : Store the carrier WAVE file of stego.

- MsgDir : Text file for storing messages.



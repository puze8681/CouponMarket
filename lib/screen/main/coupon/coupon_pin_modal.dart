import 'package:coupon_market/model/store.dart';
import 'package:flutter/material.dart';

class CouponPinModal extends StatefulWidget {
  final Store store;
  final Function onUse;

  const CouponPinModal({
    super.key,
    required this.store,
    required this.onUse,
  });

  @override
  State<CouponPinModal> createState() => _CouponPinModalState();
}

class _CouponPinModalState extends State<CouponPinModal> {
  List<String> _pinCode = [];
  final int _pinLength = 6;
  final bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들바
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          // 헤더
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '쿠폰 사용 인증',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '6자리 비밀번호를 입력해주세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // 쿠폰 정보
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                if (widget.store.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.store.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, color: Colors.grey[500]),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.confirmation_num, color: Colors.grey[500]),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store.couponTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.store.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // PIN 코드 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_pinLength, (index) {
                bool isFilled = index < _pinCode.length;
                return Container(
                  width: 40,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isFilled ? Colors.blue : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: isFilled ? Colors.blue[50] : Colors.white,
                  ),
                  child: Center(
                    child: isFilled
                        ? const Text(
                      '●',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                      ),
                    )
                        : null,
                  ),
                );
              }),
            ),
          ),

          // 에러 메시지
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage ?? "",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // 숫자 키패드
          Expanded(
            child: _isProcessing
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '쿠폰 사용 처리 중...',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : NumericKeypad(
              onNumberTap: _handleNumberInput,
              onDelete: _handleDelete,
              onClear: _handleClear,
            ),
          ),
        ],
      ),
    );
  }

  // 숫자 입력 처리
  void _handleNumberInput(String number) {
    if (_pinCode.length < _pinLength) {
      setState(() {
        _pinCode.add(number);
        _errorMessage = null;
      });

      // PIN 코드가 완성되면 검증 진행
      if (_pinCode.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  // 숫자 삭제 처리
  void _handleDelete() {
    if (_pinCode.isNotEmpty) {
      setState(() {
        _pinCode.removeLast();
        _errorMessage = null;
      });
    }
  }

  // 전체 삭제 처리
  void _handleClear() {
    setState(() {
      _pinCode = [];
      _errorMessage = null;
    });
  }

  // PIN 코드 검증 및 쿠폰 사용 처리
  Future<void> _verifyPin() async {
    final enteredPin = _pinCode.join();

    // 실제 쿠폰 코드와 비교 (이 부분은 실제 구현에 맞게 수정)
    if (enteredPin != widget.store.couponCode) {
      setState(() {
        _errorMessage = '비밀번호가 일치하지 않습니다. 다시 시도해주세요.';
        _pinCode = [];
      });
      return;
    }else{
      Navigator.of(context).pop(); // 모달 닫기
      widget.onUse.call();
    }
  }
}

// 숫자 키패드 위젯
class NumericKeypad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onDelete;
  final VoidCallback onClear;  // 전체 삭제 콜백 추가

  const NumericKeypad({
    super.key,
    required this.onNumberTap,
    required this.onDelete,
    required this.onClear,  // 생성자에 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          // 1, 2, 3
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('1'),
                _buildKeypadButton('2'),
                _buildKeypadButton('3'),
              ],
            ),
          ),
          // 4, 5, 6
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('4'),
                _buildKeypadButton('5'),
                _buildKeypadButton('6'),
              ],
            ),
          ),
          // 7, 8, 9
          Expanded(
            child: Row(
              children: [
                _buildKeypadButton('7'),
                _buildKeypadButton('8'),
                _buildKeypadButton('9'),
              ],
            ),
          ),
          // C, 0, 삭제
          Expanded(
            child: Row(
              children: [
                // 전체 삭제(C) 버튼
                Expanded(
                  child: GestureDetector(
                    onTap: onClear,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildKeypadButton('0'),
                Expanded(
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 숫자 버튼 위젯
  Widget _buildKeypadButton(String number) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onNumberTap(number),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
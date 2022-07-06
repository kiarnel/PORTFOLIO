package lotto;//package name

import java.util.Scanner;

public class lotto { //class name

	public static void main(String[] args) { // 실행 시작부
		
		/*[lotto 프로그램]
		 * 1.1~45 수 중 6개 랜덤으로 추출 
		 * 2. 로또 번호= 6자리수
		 * 3. 나의 번호 입력
		 * 4. 로또 번호와 나의 번호가 일치하는 것이 있는지 확인
		 * 5. 값이 일치하는 개수에 따라 순위 [1등 : 6, 2등 :5, 3등: 4, 꽝:1~3]
		 */
		
		//로또 번호 
		//정수로 된 배열 객체 생성
		int lotto[] = new int[6]; // lotto[] 정수로 된 6개의 숫자 배열 생성
		
		//로또번호 
		for(int i=0 ; i<6; i++) {
			lotto[i] = (int)(Math.random()*45)+1;
			
			//중복 제거 (
			for(int j=0; j<i ; j++) {
				if(lotto[i] == lotto[j]) {
					i--;
					break;
				}
			}
		}
		System.out.println("로또번호: ");
		
		for(int i=0;i<6;i++) {
			System.out.print(lotto[i]+"  ");
		}
		System.out.println("");
		//나의 번호 입력부
		int myNum[]= new int[6];
		
		Scanner sc = new Scanner(System.in);
		
		for (int i=0;i<6;i++) {
			
			System.out.println("자신이 픽한 로또 번호를 입력하세요");
			myNum[i] = sc.nextInt();
			
		}
	
		System.out.println("나의 로또 번호:");
		
		for(int i=0;i<6;i++) {
			System.out.print(myNum[i]+"  ");
		}
		
		
		//번호 일치 판단부
		int count = 0;
		for(int i=0;i<lotto.length;i++) {
			
			for(int j=0;j<myNum.length;j++) {
				
				if( lotto[i] == myNum[j]) {
						count++;
				}
				
			}
		}
		
		//맞힌 숫자 개수
		
		System.out.println("\n맞힌 숫자 개수 " + count);
		
		if( count == 6 ) {
			System.out.println("1등입니다.");
			
		}
		else if (count == 5) {
			System.out.println("2등입니다.");
		}
		else if (count == 4) {
			System.out.println("3등입니다.");
		}
		else {
			System.out.println("꽝입니다.");
		}
		
	}

}
		
		

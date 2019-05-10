<%@ page contentType="text/html; charset=euc-kr"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<title>상품 리스트</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>

<script type="text/javascript">
	//검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
		$("form").attr("method" , "POST").attr("action" , "/purchase/listPurchase").submit();
	}
	
	
	$(function() {
		$( "td:contains('수취')" ).on("click" , function() {
			self.location ="/purchase/updateTranCode?prodNo="+$(this).parent().children("td:nth-child(5)").children().val()+"&tranCode="+$(this).parent().children(  "td:nth-child(7)" ).children().val();
			console.log ( "prodNo :: "+$(this).parent().children("td:nth-child(5)").children().val());
			console.log ( "tranCode :: "+$(this).parent().children("td:nth-child(7)").children().val());
		});
		
		//구매날짜 클릭
		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			self.location ="/purchase/getPurchase?tranNo="+$(this).children().val();
			console.log ( $(this).children().val() );
		});
		
		//상품명 클릭
		$( ".ct_list_pop td:nth-child(5)" ).on("click" , function() {
			self.location ="/product/getProduct?prodNo="+$(this).children().val()+"&menu=search";
			console.log ( " :::::: "+$(this).children().val() );
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
		$( " .ct_list_pop td:nth-child(5)" ).css("font-weight" , "bold");
			
		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
			//console.log ( $(".ct_list_pop:nth-child(1)" ).html() );
	});	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">

		<form name="detailForm" >

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37" /></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="93%" class="ct_ttl01">구매목록조회</td>
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37" /></td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td colspan="11">전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
					</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="50">No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">주문번호</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">상품명</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="100">가격</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">주문현황</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">정보수정</td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>

				<c:set var="i" value="0" />
				<c:forEach var="purchase" items="${list}">
					<c:set var="i" value="${ i+1 }" />
						<tr class="ct_list_pop">
						<td align="center">${ i }</a></td>
						<td></td>
						<td align="center">${purchase.orderDate}-${purchase.tranNo}
							<input type="hidden" name="tranNo" value="${purchase.tranNo}"/></td>
						<td></td>
						<td align="center" >${purchase.purchaseProd.prodName }
							<input type="hidden" name="prodNo" value="${purchase.purchaseProd.prodNo}"/></td>
						<td></td>
						<td align="center"> ${purchase.purchaseProd.price }원
							<input type="hidden" name="tranCode" value="${purchase.tranCode}"/></td>
						<td></td>
						<td align="center">
						
							
						
						<c:choose>
							<c:when test="${purchase.tranCode eq '1' }">
								구매 완료 
							</c:when>
							<c:when test="${purchase.tranCode eq '2' }">
								배송 중 
							</c:when>
							<c:when test="${purchase.tranCode eq '3' }"> 
								배송 완료
							</c:when>
							<c:otherwise>
								????? :: ${purchase.tranCode} 
							</c:otherwise>
						</c:choose>
						
						</td>
						<td></td>
						<td align="left">
						
						<c:choose>
							<c:when test="${ purchase.tranCode eq '1'  }">
								배송 준비 중
							</c:when>	
							<c:when test="${purchase.tranCode eq '2' }">
								수취 확인
							</c:when>
							<c:when test="${ purchase.tranCode eq '3'  }">
								배송 완료
							</c:when>		
						</c:choose>
					</td>
					<td></td>
					<td align="left"></td>
					</tr>
	
					<tr>
						<td colspan="11" bgcolor="D6D7D6" height="1"></td>
					</tr>
				</c:forEach>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center">
						 <input type="hidden" id="currentPage" name="currentPage" value=""/>
							<jsp:include page="../common/pageNavigator.jsp"/>	
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>

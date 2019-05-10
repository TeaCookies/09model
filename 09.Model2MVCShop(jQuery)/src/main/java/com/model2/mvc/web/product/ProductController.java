package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;


//==> �ǸŰ��� Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method ���� ����
		
	public ProductController(){
		System.out.println(this.getClass());
	}
	
	//==> classpath:config/common.properties  ,  classpath:config/commonservice.xml ���� �Ұ�
	//==> �Ʒ��� �ΰ��� �ּ��� Ǯ�� �ǹ̸� Ȯ�� �Ұ�
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	
	
	
	@RequestMapping( value="addProductView", method=RequestMethod.GET )
	public String addProductView() throws Exception {

		System.out.println("/product/addProductView : GET");
		
		return "forward:/product/addProductView.jsp";
	}
	

	
	

	@RequestMapping( value="addProduct", method=RequestMethod.POST )
	public ModelAndView addUser( @ModelAttribute("product") Product product ) throws Exception {

		System.out.println("/product/addProduct : POST");

		System.out.println("����������������������"+product);
		//Business Logic
		productService.addProduct(product);
		
		
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/product/readProduct.jsp");
		
		return modelAndView;
	}
	
	
	
	

	@RequestMapping( value="getProduct", method=RequestMethod.GET)
	public String getProduct( @RequestParam("prodNo") int prodNo , 
								@RequestParam("menu") String menu,
								@CookieValue(value="history", required=false)  Cookie cookie ,
								Model model,
								HttpServletResponse response) throws Exception {
		
		System.out.println("/product/getProduct : GET");
		
		//Business Logic
		Product product = productService.getProduct(prodNo);
		// Model �� View ����
		model.addAttribute("product", product);	
		
		
		if ( menu.equals("manage") ) {
			return "forward:/product/updateProductView";
			
		} else {
			if ( cookie != null ) {
				if ( !( cookie.getValue().contains(Integer.toString(prodNo)) ) ) {
					cookie.setValue(cookie.getValue()+","+Integer.toString(prodNo));
					cookie.setPath("/");
					response.addCookie(cookie);
				}
			}else {
				response.addCookie(new Cookie("history", Integer.toString(prodNo)));
			}
	
		return "forward:/product/getProduct.jsp";
		}
	}
	
	
	
	
	
	@RequestMapping( value="updateProductView", method=RequestMethod.GET)
	public ModelAndView updateProductView( @RequestParam("prodNo") int prodNo ) throws Exception{

		System.out.println("/product/updateProductView : GET");
		//Business Logic
		Product product = productService.getProduct(prodNo);

		// Model �� View ����
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/product/updateProduct.jsp");
		modelAndView.addObject("product", product);
		
		return modelAndView;
	}
	
	
	
	
	@RequestMapping( value="updateProduct" , method=RequestMethod.POST)
	public ModelAndView updateProduct( @ModelAttribute("product") Product product) throws Exception{

		System.out.println("/product/updateProduct : POST");
		//Business Logic
		productService.updateProduct(product);
		product = productService.getProduct(product.getProdNo());
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/product/getProduct.jsp?prodNo="+product.getProdNo());
		modelAndView.addObject("product", product);
		
		return modelAndView;
	}
	
	
	
	

	@RequestMapping( value="listProduct" )
	public ModelAndView listProduct( @ModelAttribute("search") Search search ) throws Exception{
		
		System.out.println("/product/listProduct : GET / POST");
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		
		search.setPageSize(pageSize);
		
		// Business logic ����
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		// Model �� View ����
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("/product/listProduct.jsp");
		modelAndView.addObject("list", map.get("list"));
		modelAndView.addObject("resultPage", resultPage);
		modelAndView.addObject("search", search);
		
		return modelAndView;
	}
	
	
	
}
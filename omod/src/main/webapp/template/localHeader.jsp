<spring:htmlEscape defaultHtmlEscape="true" />
<ul id="menu">
	<li class="first">
		<a href="${pageContext.request.contextPath}/admin">
			<spring:message code="admin.title.short" />
		</a>
	</li>
	<li
		<c:if test='<%= request.getRequestURI().contains("/manage") %>'>class="active"</c:if>>
		<a href="${pageContext.request.contextPath}/module/mysqletl/manage.form">
			<spring:message code="mysqletl.manage" />
		</a>
	</li>
	<li
		<c:if test='<%= request.getRequestURI().contains("/datawarehouse") %>'>class="active"</c:if>>
		<a href="${pageContext.request.contextPath}/module/mysqletl/datawarehouse.form">
			<spring:message code="mysqletl.datawarehouse" />
		</a>
	</li>
	<li
		<c:if test='<%= request.getRequestURI().contains("/scheduler") %>'>class="active"</c:if>>
		<a href="${pageContext.request.contextPath}/module/mysqletl/scheduler.form">
			<spring:message code="mysqletl.scheduler" />
		</a>
	</li>
	<!-- Add further links here -->
</ul>
<h2>
	<spring:message code="mysqletl.title" />
</h2>

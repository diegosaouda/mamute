<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@attribute name="comment" type="org.mamute.model.Comment" required="true" %>
<%@attribute name="collapsed" type="java.lang.Boolean" required="true" %>
<%@attribute name="currentUserVote" type="org.mamute.model.Vote" required="false" %>
<li class="comment ${collapsed ? 'collapsed hidden' : ''} ${comment.isVisibleForModeratorAndNotAuthor(currentUser.current) ? 'highlight-post' : '' }" id="comment-${comment.id}">
	<div class="post-meta comment-meta vote-container">
		<span class="vote-count comment-vote-count ${comment.voteCount == 0 ? 'comment-meta-hidden' : '' }">${comment.voteCount}</span>
		<a title="<fmt:message key="comment.list.upvote"/>"  class="comment-meta-hidden container comment-option author-cant requires-login vote-option icon-up-open 
			${(not empty currentUserVote) ? 'voted' : '' }" 
			data-value="positivo" data-author="${currentUser.current.isAuthorOf(comment)}" 
			data-type="comentario" data-id="${comment.id}">
		</a>
		<c:if test="${currentUser.loggedIn && !comment.alreadyFlaggedBy(currentUser.current) && !currentUser.current.isAuthorOf(comment)}">
			<a title="<fmt:message key="flag"/>" href="#" data-author="${currentUser.current.isAuthorOf(comment)}"
			data-modal-id="comment-flag-modal${comment.id}"
			class="comment-meta-hidden container author-cant requires-login comment-option flag-it icon-flag"></a>
		</c:if>
	</div>
	<div class="comment-container">
		<span>
			${comment.htmlComment}
		</span> &#8212;
		
		<tags:userProfileLink user="${comment.author}" htmlClass="${comment.author.id eq item.author.id ? 'same-author' : ''}" isPrivate="false" /> 
		&nbsp;<tags:prettyTime time="${comment.lastUpdatedAt}"/>
	
		<fmt:message  key="edit_form.submit" var="submit"/>
		<c:if test="${currentUser.current.isAuthorOf(comment)}">
			<tags:simpleAjaxFormWith action="${linkTo[CommentController].edit(comment.id)}" 
				field="comment" onCallback="replace" callbackTarget="comment-${comment.id}" 
				submit="${submit}" value="${comment.comment}">
				<a class="requires-login requires-karma" data-author="${currentUser.current.isAuthorOf(comment)}" href="#">
					<fmt:message key="edit.link" />
				</a>
			</tags:simpleAjaxFormWith>
		</c:if>
	</div>	
</li>
<tags:flagItFor type="comentario" modalId="comment-flag-modal${comment.id}" flaggable="${comment}"/>














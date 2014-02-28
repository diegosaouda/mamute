package org.mamute.controllers;

import static org.mamute.util.TagsSplitter.splitTags;

import java.util.List;

import javax.inject.Inject;

import org.mamute.brutauth.auth.rules.ModeratorOnlyRule;
import org.mamute.dao.TagDAO;
import org.mamute.model.Tag;

import br.com.caelum.brutauth.auth.annotations.CustomBrutauthRules;
import br.com.caelum.vraptor.Controller;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Post;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.view.Results;

@Controller
public class TagController {

	@Inject private Result result;
	@Inject private TagDAO tags;

	
	@Get("/tags-similares/{tagChunk}")
	public void getTagsLike(String tagChunk){
		List<Tag> suggestions = tags.findTagsLike(tagChunk);
		result.use(Results.json()).withoutRoot().from(suggestions).serialize();
	}
	
	@Post("/tags/as6nj8f8n4aju1w2nj3u1rn5a/{stringTags}")
	@CustomBrutauthRules(ModeratorOnlyRule.class)
	public void saveTags(String stringTags){
		List<String> tagList = splitTags(stringTags);
		for (String tag : tagList) {
			if(tags.findByName(tag) == null){
				tags.save(new Tag(tag, "", null));
			}
		}
		result.nothing();
	}
	
}
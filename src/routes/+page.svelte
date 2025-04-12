<script lang="ts">
    import { content } from "$lib";

    const tagsWithDuplicates = content.sections.flatMap((section) =>
        section.entries.flatMap((entry) => entry.tags ?? []),
    );

    const tags = new Array(...new Set(tagsWithDuplicates))
        .map((current) => ({
            name: current,
            count: tagsWithDuplicates.filter((tag) => tag === current).length,
        }))
        .sort((a, b) => {
            if (a.count !== b.count) {
                return b.count - a.count;
            }
            return a.name.localeCompare(b.name);
        });
    const selectedTags = $state(new Array(tags.length).fill(false));
    const noSelectedTags = $derived(
        selectedTags.every((isSelected) => !isSelected),
    );
    const isTagSelected = $derived(
        (name: string) => selectedTags[tags.findIndex((c) => c.name === name)],
    );

    const filteredContent = $derived({
        ...content,
        sections: content.sections.map((section) => ({
            ...section,
            entries: noSelectedTags
                ? section.entries
                : section.entries.filter(
                      (entry) =>
                          entry.tags !== undefined &&
                          entry.tags.filter(isTagSelected).length > 0,
                  ),
        })),
    });
</script>

<div class="flex justify-center text-gray-900">
    <div class="flex flex-col items-center pt-10 pb-10 pl-6 pr-6 w-2xl">
        <img
            src="avatar.jpg"
            alt="аватар"
            class="w-24 rounded-full border-gray-900 shadow-lg shadow-blue-300"
        />
        <p class="font-bold mt-2 text-lg">Артём Белоусов</p>
        <p>Бэкенд разработчик</p>
        <div>
            {#each content.socials as { link, title }}
                <a href={link} class="mr-6 last:mr-0">{title}</a>
            {/each}
        </div>
        <p class="font-bold text-lg mt-2 mb-1">Теги</p>
        <div class="grid min-sm:grid-cols-4">
            {#each tags as { name, count }, i}
                <input
                    type="button"
                    value="{name} ({count})"
                    class={"col-span-1 ml-4 pl-2 pr-2 text-blue-900 cursor-pointer text-left " +
                        (selectedTags[i] ? " font-bold" : "")}
                    onclick={() => (selectedTags[i] = !selectedTags[i])}
                />
            {/each}
        </div>
        <div class="grid">
            {#each filteredContent.sections as { title, entries }}
                {#if entries.length > 0}
                    <p
                        class="font-bold flex text-lg justify-center mt-6 col-span-2"
                    >
                        {title}
                    </p>
                    {#each entries as { image, title, period, points, tags: entryTags }}
                        <div class="col-span-2 mt-2"></div>
                        <div
                            class="flex justify-center max-sm:col-span-2 max-sm:mb-1"
                        >
                            <div
                                class="size-16 rounded-full flex justify-center items-center shadow-sm shadow-blue-300 bg-blue-100 overflow-hidden"
                            >
                                <img src={image} alt="логотип" class="w-20" />
                            </div>
                        </div>
                        <div class="min-sm:ml-8 max-sm:col-span-2">
                            <p class="font-bold">{title}</p>
                            {#if period !== undefined}
                                <i>{period}</i>
                            {/if}
                            {#if entryTags !== undefined}
                                <div>
                                    {#each entryTags as tag, i}
                                        {#if i > 0}
                                            ⋅
                                        {/if}
                                        {#if isTagSelected(tag)}
                                            <b>{tag}</b>
                                        {:else}
                                            {tag}
                                        {/if}
                                    {/each}
                                </div>
                            {/if}
                            <ul class="list-disc max-sm:ml-4 mt-1 text-justify">
                                {#each points as point}
                                    <li>{@html point}</li>
                                {/each}
                            </ul>
                        </div>
                    {/each}
                {/if}
            {/each}
        </div>
    </div>
</div>

<svelte:head>
    <title>Артём Белоусов</title>
</svelte:head>
